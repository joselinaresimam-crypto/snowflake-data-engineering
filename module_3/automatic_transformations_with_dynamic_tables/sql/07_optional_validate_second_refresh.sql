-- =========================================================
-- Lección: Automatic transformations with Dynamic Tables
-- Archivo: 07_optional_validate_second_refresh.sql
-- Objetivo:
--   Confirmar que una segunda venta para la misma fecha
--   incrementa el agregado existente.
--
-- Qué estamos validando:
--   Que la dynamic table no genera una fila adicional por cada
--   pedido, sino que recalcula el resultado del GROUP BY.
-- =========================================================

SELECT
    date,
    total_sales
FROM tasty_bytes.raw_pos.daily_sales_hamburg
ORDER BY date;
