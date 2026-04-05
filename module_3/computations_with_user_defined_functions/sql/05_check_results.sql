USE ROLE accountadmin;
USE WAREHOUSE compute_wh;
USE DATABASE tasty_bytes;

-- Validar vista de Hamburg
SELECT *
FROM harmonized.weather_hamburg
ORDER BY date
LIMIT 20;

-- Validar vista analítica general
SELECT *
FROM analytics.daily_city_metrics_v
LIMIT 20;

SELECT *
FROM analytics.daily_city_metrics_v
WHERE country_desc = 'Germany'
  AND city_name = 'Hamburg'
ORDER BY date
LIMIT 20;