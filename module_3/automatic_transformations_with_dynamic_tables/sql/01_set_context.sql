-- =========================================================
-- Lección: Automatic transformations with Dynamic Tables
-- Archivo: 01_set_context.sql
-- Objetivo:
--   Definir el contexto de ejecución en Snowflake antes de
--   crear y probar la dynamic table.
--
-- Qué estamos haciendo:
--   1) Definimos el rol con el que ejecutaremos los objetos.
--   2) Indicamos el warehouse que usaremos para cómputo.
--   3) Seleccionamos la base de datos del curso.
--
-- Por qué importa:
--   En Snowflake es buena práctica fijar el contexto de forma
--   explícita para evitar ejecutar objetos en el lugar equivocado
--   o con permisos distintos a los esperados.
-- =========================================================

-- Usamos un rol con permisos amplios para seguir el laboratorio.
USE ROLE accountadmin;

-- Definimos el warehouse que se utilizará para ejecutar consultas.
USE WAREHOUSE compute_wh;

-- Seleccionamos la base de datos donde vive el dataset Tasty Bytes.
USE DATABASE tasty_bytes;