-- Overall kPIs
SELECT
    COUNT(*) AS total_appointments,
    SUM(is_no_show) AS total_no_shows,
    ROUND(SUM(is_no_show) * 100.0 / COUNT(*), 2) AS no_show_rate_pct,
    ROUND(AVG(wait_time_minutes), 1) AS avg_wait_time_mins,
    ROUND(MAX(wait_time_minutes), 1) AS max_wait_time_mins,
    COUNT(DISTINCT patient_id) AS unique_patients,
    COUNT(DISTINCT provider_id) AS unique_providers,
    COUNT(DISTINCT clinic_id) AS total_clinics
FROM fact_appointments;