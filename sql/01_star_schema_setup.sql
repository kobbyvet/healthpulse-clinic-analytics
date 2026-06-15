--creating clinic table
CREATE TABLE dim_clinics AS
SELECT DISTINCT
    clinic_id,
    clinic_name,
    city,
    hours AS operating_hours
FROM staging_appointments
ORDER BY clinic_id;


--creating patients table 
CREATE TABLE dim_patients AS
SELECT DISTINCT
    patient_id,
    insurance_type,
    age,
    CASE
        WHEN age < 18 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 34 THEN '18-34'
        WHEN age BETWEEN 35 AND 54 THEN '35-54'
        WHEN age BETWEEN 55 AND 74 THEN '55-74'
        ELSE '75+'
    END AS age_group
FROM staging_appointments
ORDER BY patient_id;

--creating providers table 
CREATE TABLE dim_providers AS
SELECT DISTINCT
    provider_id,
    specialty,
    clinic_id,
    clinic_assignment
FROM staging_appointments
ORDER BY provider_id;


CREATE TABLE dim_dates AS
SELECT DISTINCT ON (appointment_date::DATE)
    ROW_NUMBER() OVER (ORDER BY appointment_date::DATE) AS date_id,
    appointment_date::DATE AS appointment_date,
    TO_CHAR(appointment_date::DATE, 'Dy') AS day_of_week,
    TO_CHAR(appointment_date::DATE, 'Mon') AS month_name,
    EXTRACT(YEAR FROM appointment_date::DATE)::INTEGER AS year,
    CASE
        WHEN TO_CHAR(appointment_date::DATE, 'Dy')
        IN ('Sat', 'Sun') THEN 1 ELSE 0
    END AS is_weekend
FROM staging_appointments
ORDER BY appointment_date::DATE;


--creating the fact table
CREATE TABLE fact_appointments AS
SELECT
    s.appointment_id,
    s.patient_id,
    s.clinic_id,
    s.provider_id,
    d.date_id,
    s.appointment_time,
    s.appointment_date::DATE AS appointment_date,
    s.lead_time_days,
    s.wait_time_minutes,
    s.is_no_show
FROM staging_appointments s
JOIN dim_dates d
    ON s.appointment_date::DATE = d.appointment_date;


