-- =========================================================
-- Paso 6: Crear vista de monitoreo de viento en Hamburg
--
-- Objetivo:
-- Crear una vista reutilizable para monitorear la velocidad
-- del viento en Hamburg a lo largo del tiempo.
--
-- ¿Por qué es importante?
-- Convertimos un análisis puntual en un activo analítico
-- que puede usarse para dashboards, alertas o monitoreo continuo.
-- =========================================================

CREATE OR REPLACE VIEW tasty_bytes.harmonized.windspeed_hamburg AS
SELECT
    dw.country_desc,
    dw.city_name,
    dw.date_valid_std,
    MAX(dw.max_wind_speed_100m_mph) AS max_wind_speed_100m_mph
FROM harmonized.daily_weather_v dw
WHERE 1 = 1
    AND dw.country_desc IN ('Germany')
    AND dw.city_name = 'Hamburg'
GROUP BY
    dw.country_desc,
    dw.city_name,
    dw.date_valid_std
ORDER BY dw.date_valid_std DESC;