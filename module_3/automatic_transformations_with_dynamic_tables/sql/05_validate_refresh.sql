-- =========================================================
-- Lección: Automatic transformations with Dynamic Tables
-- Archivo: 05_validate_refresh.sql
-- Objetivo:
--   Verificar si la dynamic table ya reflejó el cambio
--   realizado en la tabla fuente.
--
-- Qué estamos haciendo:
--   Consultamos nuevamente la dynamic table después del insert.
--
-- Importante:
--   Como definimos TARGET_LAG = '1 minute', es posible que
--   inmediatamente después del INSERT todavía no veamos el cambio.
--   Si eso pasa, no significa que esté mal.
--
-- Qué debemos hacer:
--   1) Ejecutar esta consulta inmediatamente después del insert.
--   2) Si aún no cambia, esperar aproximadamente 1 minuto.
--   3) Ejecutarla de nuevo para observar el refresco automático.
--
-- Qué esperamos:
--   Ver que la fecha 2024-03-09 aparezca o incremente su
--   total de ventas según la información que ya existía.
-- =========================================================

SELECT
    date,
    total_sales
FROM tasty_bytes.raw_pos.daily_sales_hamburg
ORDER BY date;