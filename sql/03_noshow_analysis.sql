-- ============================================
-- Query 4: No-Show Rate by Day of Week
-- ============================================
SELECT
    dd.day_of_week,
    COUNT(*) AS total_appointments,
    SUM(fa.is_no_show) AS total_no_shows,
    ROUND(SUM(fa.is_no_show) * 100.0 / COUNT(*), 2) AS no_show_rate_pct
FROM fact_appointments fa
JOIN dim_dates dd ON fa.date_id = dd.date_id
GROUP BY dd.day_of_week
ORDER BY no_show_rate_pct DESC;


-- ============================================
-- Query 5: No-Show Rate by Insurance Type
-- ============================================
SELECT
    dp.insurance_type,
    COUNT(*) AS total_appointments,
    SUM(fa.is_no_show) AS total_no_shows,
    ROUND(SUM(fa.is_no_show) * 100.0 / COUNT(*), 2) AS no_show_rate_pct
FROM fact_appointments fa
JOIN dim_patients dp ON fa.patient_id = dp.patient_id
GROUP BY dp.insurance_type
ORDER BY no_show_rate_pct DESC;


-- ============================================
-- Query 6: No-Show Rate by Age Group
-- ============================================
SELECT
    dp.age_group,
    COUNT(*) AS total_appointments,
    SUM(fa.is_no_show) AS total_no_shows,
    ROUND(SUM(fa.is_no_show) * 100.0 / COUNT(*), 2) AS no_show_rate_pct
FROM fact_appointments fa
JOIN dim_patients dp ON fa.patient_id = dp.patient_id
GROUP BY dp.age_group
ORDER BY no_show_rate_pct DESC;


-- ============================================
-- Query 7: No-Show Rate by Booking Lead Time
-- ============================================
SELECT
    CASE
        WHEN lead_time_days = 0 THEN 'Same Day'
        WHEN lead_time_days BETWEEN 1 AND 7 THEN '1-7 Days'
        WHEN lead_time_days BETWEEN 8 AND 14 THEN '8-14 Days'
        WHEN lead_time_days BETWEEN 15 AND 21 THEN '15-21 Days'
        ELSE '22+ Days'
    END AS lead_time_bucket,
    COUNT(*) AS total_appointments,
    SUM(is_no_show) AS total_no_shows,
    ROUND(SUM(is_no_show) * 100.0 / COUNT(*), 2) AS no_show_rate_pct
FROM fact_appointments
GROUP BY lead_time_bucket
ORDER BY no_show_rate_pct DESC;