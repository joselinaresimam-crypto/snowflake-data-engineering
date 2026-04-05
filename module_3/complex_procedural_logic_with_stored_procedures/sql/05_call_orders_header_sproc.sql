-- =========================================================
-- 05_call_orders_header_sproc.sql
-- Objetivo:
--   Ejecutar el stored procedure que procesa el stream.
--
-- ¿Qué debe pasar al correrlo?
--   1. El procedure consulta el stream.
--   2. Identifica inserts recientes.
--   3. Filtra pedidos de Hamburg, Germany.
--   4. Agrega las ventas por día.
--   5. Escribe el resultado en la tabla destino.
-- =========================================================

CALL tasty_bytes.raw_pos.process_order_headers_stream();