-- =========================================================
-- Lección: Data transformations with SQL
-- Paso 1: Definir contexto de ejecución en Snowflake
--
-- Objetivo:
-- Establecer el rol, warehouse y base de datos que se utilizarán
-- para ejecutar las transformaciones de esta lección.
--
-- Importante:
-- Este script debe ejecutarse antes que cualquier otro.
-- =========================================================

USE ROLE accountadmin;
USE WAREHOUSE compute_wh;
USE DATABASE tasty_bytes;