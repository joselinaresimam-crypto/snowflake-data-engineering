-- =========================================================
-- 02_validate_udfs.sql
-- Objetivo:
--   Validar que las UDFs creadas regresen los resultados
--   esperados antes de utilizarlas en vistas.
-- =========================================================

-- ---------------------------------------------------------
-- 1) Definir contexto de trabajo
-- ---------------------------------------------------------
USE ROLE accountadmin;
USE WAREHOUSE compute_wh;
USE DATABASE tasty_bytes;
USE SCHEMA analytics;

-- ---------------------------------------------------------
-- 2) Validación rápida con valores conocidos
-- ---------------------------------------------------------
SELECT
    32 AS temp_f_1,
    fahrenheit_to_celsius(32) AS temp_c_1,
    212 AS temp_f_2,
    fahrenheit_to_celsius(212) AS temp_c_2,
    1 AS inch_1,
    inch_to_millimeter(1) AS mm_1,
    0 AS inch_2,
    inch_to_millimeter(0) AS mm_2
;

-- Resultado esperado:
-- 32°F   -> 0°C
-- 212°F  -> 100°C
-- 1 inch -> 25.4 mm
-- 0 inch -> 0 mm

-- ---------------------------------------------------------
-- 3) Validación con redondeo para presentación
-- ---------------------------------------------------------
SELECT
    ROUND(fahrenheit_to_celsius(77), 2) AS celsius_from_77f,
    ROUND(inch_to_millimeter(2.5), 2) AS millimeters_from_2_5_inches
;