
-- ###########################################
-- tomamos el archivo del stage
-- lo carga en la tabla sample_menu_copy_into
-- ###########################################

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE LOAD_DATA;
USE SCHEMA PUBLIC;

COPY INTO sample_menu_copy_into
FROM @blob_stage/raw_pos/menu/;