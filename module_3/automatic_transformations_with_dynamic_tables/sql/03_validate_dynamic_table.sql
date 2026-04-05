-- =========================================================
-- Lección: Automatic transformations with Dynamic Tables
-- Archivo: 03_validate_dynamic_table.sql
-- Objetivo:
--   Validar que la dynamic table se haya creado correctamente
--   y revisar su contenido inicial.
--
-- Qué estamos haciendo:
--   Consultamos la tabla derivada que acabamos de crear para
--   confirmar que:
--     1) existe
--     2) tiene datos
--     3) refleja el agregado esperado por fecha
--
-- Qué esperamos:
--   Ver una tabla con dos columnas:
--     - DATE
--     - TOTAL_SALES
--   donde cada fila representa las ventas agregadas por día
--   para Hamburg, Germany.
-- =========================================================

SELECT
    date,
    total_sales
FROM tasty_bytes.raw_pos.daily_sales_hamburg
ORDER BY date;