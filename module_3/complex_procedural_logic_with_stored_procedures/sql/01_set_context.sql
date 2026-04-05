-- =========================================================
-- 01_set_context.sql
-- Lección: Complex procedural logic with stored procedures
-- Objetivo:
--   Definir el contexto de trabajo en Snowflake antes de
--   crear y ejecutar el stored procedure.
--
-- ¿Qué hace este script?
--   1. Selecciona el rol con el que trabajaremos.
--   2. Selecciona el warehouse que dará capacidad de cómputo.
--   3. Selecciona la base de datos del proyecto.
--
-- Nota:
--   Este paso es importante porque muchos errores en Snowflake
--   ocurren simplemente por no tener bien definido el contexto.
-- =========================================================

USE ROLE accountadmin;
USE WAREHOUSE compute_wh;
USE DATABASE tasty_bytes;