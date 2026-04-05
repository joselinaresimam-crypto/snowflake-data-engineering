-- Paso 5: Eliminar el registro dummy de la tabla base
DELETE
FROM tasty_bytes.raw_pos.order_header
WHERE order_id = 123456789;

-- Paso 6: Consultar nuevamente el stream
-- Nota: en un standard stream esta consulta no necesariamente devolverá
-- el delete como intuitivamente podríamos esperar, debido a cómo Snowflake
-- maneja el offset y el consumo del stream.
SELECT *
FROM tasty_bytes.raw_pos.order_header_stream;