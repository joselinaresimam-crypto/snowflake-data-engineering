
-- ###########################################################
-- consulta la tabla ya cargada
-- y nos debe mostrar las 100 filas que contiene el dataset
-- ###########################################################

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE LOAD_DATA;
USE SCHEMA PUBLIC;

SELECT *
FROM sample_menu_copy_into;