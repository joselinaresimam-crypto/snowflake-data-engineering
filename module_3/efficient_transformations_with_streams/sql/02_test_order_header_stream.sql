-- Paso 3: Insertar un registro de prueba para validar que el stream capture cambios
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
    123456789,                     -- ORDER_ID
    101,                           -- TRUCK_ID
    1234,                          -- LOCATION_ID
    NULL,                          -- CUSTOMER_ID
    NULL,                          -- DISCOUNT_ID
    123456789,                     -- SHIFT_ID
    '08:00:00',                    -- SHIFT_START_TIME
    '16:00:00',                    -- SHIFT_END_TIME
    NULL,                          -- ORDER_CHANNEL
    '2023-07-01 12:30:45',         -- ORDER_TS
    NULL,                          -- SERVED_TS
    'USD',                         -- ORDER_CURRENCY
    50.00,                         -- ORDER_AMOUNT
    NULL,                          -- ORDER_TAX_AMOUNT
    NULL,                          -- ORDER_DISCOUNT_AMOUNT
    52.50                          -- ORDER_TOTAL
);

-- Paso 4: Consultar el stream para verificar que detectó el nuevo registro
SELECT *
FROM tasty_bytes.raw_pos.order_header_stream;