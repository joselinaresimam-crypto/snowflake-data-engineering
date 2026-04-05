-- =========================================================
-- 04_create_daily_city_metrics_view.sql
-- Objetivo:
--   Crear una vista analítica general con métricas diarias
--   de clima y ventas para todas las ciudades.
-- =========================================================

-- ---------------------------------------------------------
-- 1) Definir contexto de trabajo
-- ---------------------------------------------------------
USE ROLE accountadmin;
USE WAREHOUSE compute_wh;
USE DATABASE tasty_bytes;

-- ---------------------------------------------------------
-- 2) Crear o reemplazar la vista analytics.daily_city_metrics_v
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW analytics.daily_city_metrics_v
COMMENT = 'Daily Weather Metrics and Orders Data'
AS
SELECT
    fd.date_valid_std AS date,
    fd.city_name,
    fd.country_desc,
    ZEROIFNULL(SUM(odv.price)) AS daily_sales,
    ROUND(AVG(fd.avg_temperature_air_2m_f), 2) AS avg_temperature_fahrenheit,
    ROUND(AVG(analytics.fahrenheit_to_celsius(fd.avg_temperature_air_2m_f)), 2) AS avg_temperature_celsius,
    ROUND(AVG(fd.tot_precipitation_in), 2) AS avg_precipitation_inches,
    ROUND(AVG(analytics.inch_to_millimeter(fd.tot_precipitation_in)), 2) AS avg_precipitation_millimeters,
    MAX(fd.max_wind_speed_100m_mph) AS max_wind_speed_100m_mph
FROM tasty_bytes.harmonized.daily_weather_v fd
LEFT JOIN tasty_bytes.harmonized.orders_v odv
    ON fd.date_valid_std = DATE(odv.order_ts)
    AND fd.city_name = odv.primary_city
    AND fd.country_desc = odv.country
GROUP BY
    fd.date_valid_std,
    fd.city_name,
    fd.country_desc
;