-- =========================================================
-- Paso 2: Identificar días con ventas en cero en Hamburg
--
-- Objetivo:
-- Detectar exactamente qué días de febrero 2022 las ventas
-- en Hamburg, Alemania, fueron igual a cero.
--
-- ¿Qué se hace?
-- 1. Se genera una tabla de fechas para todo febrero 2022.
-- 2. Se hace un LEFT JOIN contra las órdenes.
-- 3. Se usa ZEROIFNULL para convertir valores nulos en 0.
--
-- ¿Por qué es importante?
-- Si solo consultamos la tabla de órdenes, los días sin ventas
-- no aparecerían. Con este enfoque podemos detectar anomalías.
-- =========================================================

WITH _feb_date_dim AS (
    SELECT DATEADD(DAY, SEQ4(), '2022-02-01') AS date
    FROM TABLE(GENERATOR(ROWCOUNT => 28))
)
SELECT
    fdd.date,
    ZEROIFNULL(SUM(o.price)) AS daily_sales
FROM _feb_date_dim fdd
LEFT JOIN analytics.orders_v o
    ON fdd.date = DATE(o.order_ts)
    AND o.country = 'Germany'
    AND o.primary_city = 'Hamburg'
WHERE fdd.date BETWEEN '2022-02-01' AND '2022-02-28'
GROUP BY fdd.date
ORDER BY fdd.date ASC;