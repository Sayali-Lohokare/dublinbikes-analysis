-- Top 10 stations most often empty during morning peak (8-9am)
SELECT 
    NAME,
    ROUND(100.0 * SUM(CASE WHEN AVAILABLE_BIKES = 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_empty_morning
FROM bikes
WHERE hour IN (8, 9) AND NAME NOT LIKE '%TEST%'
GROUP BY NAME
ORDER BY pct_empty_morning DESC
LIMIT 10;

-- Average bikes available: weekday vs weekend
SELECT 
    is_weekend,
    ROUND(AVG(AVAILABLE_BIKES), 2) AS avg_available_bikes
FROM bikes
GROUP BY is_weekend;
