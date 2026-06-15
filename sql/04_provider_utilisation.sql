--Provider Utilisation rate
SELECT
    dp.provider_id,
    dp.specialty,
    dp.clinic_id,
    dp.clinic_assignment,
    COUNT(*) AS total_appointments,
    SUM(fa.is_no_show) AS total_no_shows,
    COUNT(*) - SUM(fa.is_no_show) AS attended_appointments,
    ROUND((COUNT(*) - SUM(fa.is_no_show)) * 100.0 / COUNT(*), 1) AS utilisation_pct,
    ROUND(AVG(fa.wait_time_minutes), 1) AS avg_wait_time
FROM fact_appointments fa
JOIN dim_providers dp ON fa.provider_id = dp.provider_id
GROUP BY dp.provider_id, dp.specialty, dp.clinic_id, dp.clinic_assignment
ORDER BY utilisation_pct DESC;

--utilisation by specialty
SELECT
    dp.specialty,
    COUNT(DISTINCT dp.provider_id) AS total_providers,
    COUNT(*) AS total_appointments,
    ROUND((COUNT(*) - SUM(fa.is_no_show)) * 100.0 / COUNT(*), 1) AS utilisation_pct,
    ROUND(AVG(fa.wait_time_minutes), 1) AS avg_wait_time,
    SUM(fa.is_no_show) AS total_no_shows
FROM fact_appointments fa
JOIN dim_providers dp ON fa.provider_id = dp.provider_id
GROUP BY dp.specialty
ORDER BY utilisation_pct DESC;

--overloaded vs underused providers
SELECT
    utilisation_category,
    COUNT(*) AS provider_count,
    ROUND(AVG(utilisation_pct), 1) AS avg_utilisation,
    ROUND(AVG(avg_wait_time), 1) AS avg_wait_time
FROM (
    SELECT
        dp.provider_id,
        dp.specialty,
        dp.clinic_assignment,
        ROUND((COUNT(*) - SUM(fa.is_no_show)) * 100.0 / COUNT(*), 1) AS utilisation_pct,
        ROUND(AVG(fa.wait_time_minutes), 1) AS avg_wait_time,
        CASE
            WHEN ROUND((COUNT(*) - SUM(fa.is_no_show)) * 100.0 / COUNT(*), 1) >= 85 
                THEN 'Overloaded (85%+)'
            WHEN ROUND((COUNT(*) - SUM(fa.is_no_show)) * 100.0 / COUNT(*), 1) >= 70 
                THEN 'Optimal (70-84%)'
            ELSE 'Underused (Below 70%)'
        END AS utilisation_category
    FROM fact_appointments fa
    JOIN dim_providers dp ON fa.provider_id = dp.provider_id
    GROUP BY dp.provider_id, dp.specialty, dp.clinic_assignment
) categorised
GROUP BY utilisation_category
ORDER BY avg_utilisation DESC;