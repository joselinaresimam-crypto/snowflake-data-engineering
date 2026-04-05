-- =========================================================
-- Paso 3: Crear vista de clima (capa HARMONIZED)
--
-- Objetivo:
-- Construir una vista que integre datos de clima con información
-- de ciudad y país para las ubicaciones donde opera Tasty Bytes.
--
-- ¿Qué se hace?
-- Se unen:
-- - Datos históricos de clima (Marketplace)
-- - Información de códigos postales
-- - Información de país y ciudad de Tasty Bytes
--
-- ¿Por qué es importante?
-- En lugar de trabajar directamente con datos raw del clima,
-- creamos una capa harmonized reutilizable para análisis futuros.
-- =========================================================

CREATE OR REPLACE VIEW tasty_bytes.harmonized.daily_weather_v
COMMENT = 'Vista de clima diario enriquecida para ciudades de Tasty Bytes'
AS
SELECT
    hd.*,
    TO_VARCHAR(hd.date_valid_std, 'YYYY-MM') AS yyyy_mm,
    pc.city_name AS city,
    c.country AS country_desc
FROM FROSTBYTE_WEATHERSOURCE.onpoint_id.history_day hd
JOIN FROSTBYTE_WEATHERSOURCE.onpoint_id.postal_codes pc
    ON pc.postal_code = hd.postal_code
    AND pc.country = hd.country
JOIN TASTY_BYTES.raw_pos.country c
    ON c.iso_country = hd.country
    AND c.city = hd.city_name;