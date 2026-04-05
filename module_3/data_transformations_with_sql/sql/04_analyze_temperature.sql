-- =========================================================
-- Paso 4: Analizar temperatura en Hamburg
--
-- Objetivo:
-- Evaluar si la temperatura pudo haber causado la caída
-- de ventas en febrero 2022.
--
-- ¿Qué se hace?
-- Se calcula la temperatura promedio diaria en Hamburg.
--
-- ¿Qué buscamos?
-- Identificar valores fuera de lo normal que expliquen la anomalía.
-- =========================================================

SELECT
    dw.country_desc,
    dw.city_name,
    dw.date_valid_std,
    AVG(dw.avg_temperature_air_2m_f) AS avg_temperature_air_2m_f
FROM harmonized.daily_weather_v dw
WHERE 1 = 1
    AND dw.country_desc = 'Germany'
    AND dw.city_name = 'Hamburg'
    AND YEAR(date_valid_std) = '2022'
    AND MONTH(date_valid_std) = '2' -- Febrero
GROUP BY
    dw.country_desc,
    dw.city_name,
    dw.date_valid_std
ORDER BY dw.date_valid_std DESC;