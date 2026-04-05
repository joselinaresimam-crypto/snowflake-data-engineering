-- =========================================================
-- 03_insert_dummy_order_data.sql
-- Objetivo:
--   Insertar un registro de prueba en order_header para que
--   el stream detecte un nuevo pedido y el stored procedure
--   tenga algo que procesar.
--
-- ¿Qué validamos con esto?
--   Que el flujo completo funcione:
--   tabla origen -> stream -> stored procedure -> tabla destino
--
-- Nota:
--   El LOCATION_ID = 4493 corresponde al caso que el curso
--   usa para Hamburg.
-- =========================================================

INSERT INTO tasty_bytes.raw_pos.order_header (
    ORDER_ID, 
    TRUCK_ID, 
    LOCATION_ID, 
    CUSTOMER_ID, 
    DISCOUNT_ID, 
    SHIFT_ID, 
    SHIFT_START_TIME, 
    SHIFT_END_TIME, 
    ORDER_CHANNEL, 
    ORDER_TS, 
    SERVED_TS, 
    ORDER_CURRENCY, 
    ORDER_AMOUNT, 
    ORDER_TAX_AMOUNT, 
    ORDER_DISCOUNT_AMOUNT, 
    ORDER_TOTAL
) VALUES (
    123456789,                     -- Identificador único del pedido
    101,                           -- Truck asociado al pedido
    4493,                          -- Ubicación del pedido (caso Hamburg)
    null,                          -- Cliente no especificado para esta prueba
    null,                          -- Descuento no especificado
    123456789,                     -- Shift de referencia
    '08:00:00',                    -- Hora de inicio del turno
    '16:00:00',                    -- Hora de fin del turno
    null,                          -- Canal no especificado
    '2023-07-01 12:30:45',         -- Timestamp del pedido
    null,                          -- Hora de servicio no especificada
    'USD',                         -- Moneda
    41.30,                         -- Monto base
    null,                          -- Impuesto no especificado
    null,                          -- Descuento no especificado
    45.80                          -- Total final del pedido
);