
-- #####################################
-- creamos un stage externo
-- apuntamos al bucket público de S3
-- definimos que los archivos son CSV
-- #####################################

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE LOAD_DATA;
USE SCHEMA PUBLIC;

CREATE OR REPLACE STAGE blob_stage
URL = 's3://sfquickstarts/tastybytes/'
FILE_FORMAT = (TYPE = CSV);