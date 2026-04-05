-- =========================================================
-- Lección: Automatic transformations with Dynamic Tables
-- Archivo: 04_insert_dummy_sale.sql
-- Objetivo:
--   Insertar una venta dummy en la tabla fuente para comprobar
--   que la dynamic table se refresca automáticamente.
--
-- Qué estamos haciendo:
--   Insertamos un nuevo pedido en raw_pos.order_header.
--
-- Por qué importa:
--   La dynamic table NO se actualiza porque le insertamos datos
--   directamente a ella, sino porque cambia su tabla fuente.
--   Esto nos permite comprobar que Snowflake detecta el cambio
--   y actualiza el resultado agregado.
--
-- Qué esperamos:
--   Como el pedido corresponde a Hamburg y tiene fecha
--   2024-03-09, después del refresh automático debemos ver:
--     - una nueva fila para esa fecha, o
--     - un incremento en el total de ventas de esa fecha
--   dependiendo de si ya existía información para ese día.
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
    123456789,             -- Identificador único del pedido dummy
    101,                   -- Camión o punto de venta asociado
    4493,                  -- Ubicación que el laboratorio usa para Hamburg
    NULL,                  -- Cliente no especificado
    NULL,                  -- Descuento no especificado
    123456789,             -- Shift dummy para la prueba
    '08:00:00',            -- Hora de inicio del turno
    '16:00:00',            -- Hora de fin del turno
    NULL,                  -- Canal de pedido no especificado
    '2024-03-09 12:30:45', -- Fecha/hora del pedido
    NULL,                  -- Hora de servicio no especificada
    'USD',                 -- Moneda del pedido
    12.00,                 -- Monto base del pedido
    NULL,                  -- Impuesto no especificado
    NULL,                  -- Descuento no especificado
    12.35                  -- Total final del pedido
);