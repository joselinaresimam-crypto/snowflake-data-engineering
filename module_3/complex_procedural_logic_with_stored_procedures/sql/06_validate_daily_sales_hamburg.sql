-- =========================================================
-- 06_validate_daily_sales_hamburg.sql
-- Objetivo:
--   Validar que el stored procedure escribió correctamente
--   el resultado en la tabla raw_pos.daily_sales_hamburg_t.
--
-- Resultado esperado:
--   Debe verse reflejada la venta del pedido insertado,
--   con total de 45.80 para la fecha correspondiente.
-- =========================================================

SELECT *
FROM tasty_bytes.raw_pos.daily_sales_hamburg_t;