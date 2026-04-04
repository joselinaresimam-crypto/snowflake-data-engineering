
-- #####################################################
-- listamos los archivos disponibles en esa ruta del stage
-- aquí deberiamos ver menu.csv.gz
-- #####################################################

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE LOAD_DATA;
USE SCHEMA PUBLIC;

LIST @blob_stage/raw_pos/menu/;