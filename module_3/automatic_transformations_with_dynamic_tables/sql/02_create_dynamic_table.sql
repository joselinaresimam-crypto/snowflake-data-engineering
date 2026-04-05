-- =========================================================
-- Lección: Automatic transformations with Dynamic Tables
-- Archivo: 02_create_dynamic_table.sql
-- Objetivo:
--   Crear una dynamic table que calcule automáticamente las
--   ventas diarias de Hamburg, Germany.
--
-- Qué estamos haciendo:
--   1) Creamos o reemplazamos la dynamic table destino.
--   2) Indicamos qué warehouse usará Snowflake para refrescarla.
--   3) Definimos la frescura objetivo con TARGET_LAG.
--   4) Especificamos la consulta SQL que genera el resultado.
--
-- Concepto clave:
--   Una dynamic table mantiene actualizado el resultado de una
--   transformación sin que tengamos que construir manualmente
--   un flujo con stream + stored procedure + task.
--
-- Qué esperamos:
--   Después de crearla, Snowflake materializará una tabla con:
--     - la fecha del pedido
--     - el total de ventas de ese día
--   pero solo para pedidos realizados en Hamburg, Germany.
-- =========================================================

CREATE OR REPLACE DYNAMIC TABLE tasty_bytes.raw_pos.daily_sales_hamburg
    -- Warehouse que Snowflake usará para poblar y refrescar
    -- esta dynamic table.
    WAREHOUSE = 'COMPUTE_WH'

    -- Frescura objetivo de la tabla.
    -- En esta práctica usamos 1 minuto para poder observar
    -- el refresco automático sin esperar demasiado.
    TARGET_LAG = '1 minute'
AS
SELECT
    -- Convertimos el timestamp del pedido a solo fecha para
    -- poder agrupar las ventas a nivel diario.
    CAST(oh.ORDER_TS AS DATE) AS date,

    -- Sumamos el total de cada pedido para obtener las ventas
    -- diarias. COALESCE se usa como práctica defensiva para
    -- evitar nulos en el resultado.
    COALESCE(SUM(oh.ORDER_TOTAL), 0) AS total_sales
FROM tasty_bytes.raw_pos.order_header oh

-- Hacemos join con la tabla de ubicaciones para identificar
-- en qué ciudad y país ocurrió cada pedido.
JOIN tasty_bytes.raw_pos.location loc
    ON oh.LOCATION_ID = loc.LOCATION_ID

WHERE
    -- Filtramos únicamente los pedidos de Hamburg, Germany,
    -- ya que esta tabla derivada está enfocada en ese caso
    -- de negocio específico.
    loc.CITY = 'Hamburg'
    AND loc.COUNTRY = 'Germany'

-- Agrupamos por fecha para obtener una fila por día con el
-- total de ventas agregado.
GROUP BY CAST(oh.ORDER_TS AS DATE);