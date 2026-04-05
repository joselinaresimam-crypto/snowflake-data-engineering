-- =========================================================
-- 04_validate_order_header_insert.sql
-- Objetivo:
--   Validar que el registro de prueba sí quedó insertado
--   correctamente en la tabla origen.
--
-- ¿Por qué importa?
--   Antes de ejecutar el stored procedure conviene confirmar
--   que el dato realmente existe en order_header.
-- =========================================================

SELECT *
FROM tasty_bytes.raw_pos.order_header
WHERE location_id = 4493;