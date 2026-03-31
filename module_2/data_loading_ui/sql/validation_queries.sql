-- Este script valida la carga de datos realizada previamente desde Snowsight.
-- Antes de ejecutar este query, asegúrate de haber hecho lo siguiente en la interfaz web de Snowflake:
-- 1. Cargar el archivo sample_orders.csv
-- 2. Crear la base de datos LOAD_DATA
-- 3. Usar el schema PUBLIC
-- 4. Crear la tabla SAMPLE_ORDERS_UI

USE DATABASE LOAD_DATA;
USE SCHEMA PUBLIC;

SELECT *
FROM SAMPLE_ORDERS_UI
LIMIT 10;