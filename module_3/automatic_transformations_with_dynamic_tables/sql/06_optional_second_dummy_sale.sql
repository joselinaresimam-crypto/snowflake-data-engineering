-- =========================================================
-- Lección: Automatic transformations with Dynamic Tables
-- Archivo: 06_optional_second_dummy_sale.sql
-- Objetivo:
--   Insertar una segunda venta dummy para la misma fecha y
--   comprobar que la dynamic table actualiza el agregado.
--
-- Qué estamos haciendo:
--   Insertamos un nuevo pedido para Hamburg en la misma fecha
--   2024-03-09, pero con un total distinto.
--
-- Qué esperamos:
--   Después del refresh automático:
--     - NO debería aparecer una fila nueva para 2024-03-09
--     - SÍ debería aumentar el total_sales de esa fecha
--
-- Aprendizaje clave:
--   La dynamic table mantiene el resultado del SELECT agregado,
--   no un detalle transaccional fila por fila.
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
)
VALUES (
    123456790,             -- Nuevo ORDER_ID para no duplicar la llave
    101,
    4493,
    NULL,
    NULL,
    123456790,
    '08:00:00',
    '16:00:00',
    NULL,
    '2024-03-09 14:10:00', -- Misma fecha, distinta hora
    NULL,
    'USD',
    20.00,
    NULL,
    NULL,
    20.50                  -- Nuevo total que deberá sumarse al agregado
);