-- =========================================================
-- 01_create_udfs.sql
-- Lección: Computations with user-defined functions
-- Objetivo:
--   Crear funciones definidas por el usuario (UDFs) para
--   reutilizar lógica de conversión de unidades.
-- =========================================================

-- ---------------------------------------------------------
-- 1) Definir contexto de trabajo
-- ---------------------------------------------------------
USE ROLE accountadmin;
USE WAREHOUSE compute_wh;
USE DATABASE tasty_bytes;
USE SCHEMA analytics;

-- ---------------------------------------------------------
-- 2) UDF: Fahrenheit a Celsius
--    Fórmula: (F - 32) * 5 / 9
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION fahrenheit_to_celsius(temp_f NUMBER(35,4))
RETURNS NUMBER(35,4)
AS
$$
    (temp_f - 32) * (5/9)
$$
;

-- ---------------------------------------------------------
-- 3) UDF: Pulgadas a milímetros
--    Fórmula: pulgadas * 25.4
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION inch_to_millimeter(inch NUMBER(35,4))
RETURNS NUMBER(35,4)
AS
$$
    inch * 25.4
$$
;