-- =========================================================
-- Paso 5: Analizar velocidad del viento en Hamburg
--
-- Objetivo:
-- Determinar si condiciones extremas de viento pudieron haber
-- causado la caída en ventas.
--
-- ¿Qué se hace?
-- Se obtiene la velocidad máxima diaria del viento.
--
-- Insight esperado:
-- Detectar valores extremadamente altos que expliquen
-- la falta de actividad comercial.
-- =========================================================

SELECT
    dw.country_desc,
    dw.city_name,
    dw.date_valid_std,
    MAX(dw.max_wind_speed_100m_mph) AS max_wind_speed_100m_mph
FROM tasty_bytes.harmonized.daily_weather_v dw
WHERE 1 = 1
    AND dw.country_desc IN ('Germany')
    AND dw.city_name = 'Hamburg'
    AND YEAR(date_valid_std) = '2022'
    AND MONTH(date_valid_std) = '2' -- Febrero
GROUP BY
    dw.country_desc,
    dw.city_name,
    dw.date_valid_std
ORDER BY dw.date_valid_std DESC;