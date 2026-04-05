-- Lección: Efficient transformations with streams
-- Paso 1: Definir contexto de trabajo en Snowflake
USE ROLE accountadmin;
USE WAREHOUSE compute_wh;
USE DATABASE tasty_bytes;
USE SCHEMA raw_pos;

-- Paso 2: Crear stream sobre la tabla order_header
CREATE OR REPLACE STREAM tasty_bytes.raw_pos.order_header_stream
ON TABLE tasty_bytes.raw_pos.order_header;