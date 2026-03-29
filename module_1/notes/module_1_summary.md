# Module 1 - Build a really simple data pipeline in Snowflake

## Objetivo
Construir un pipeline simple en Snowflake que cubra:
- ingestión
- transformación
- entrega

## Estructura del proyecto
- data/raw_economic_data.csv
- sql/01_setup_raw.sql
- sql/02_transformations.sql
- app/03_streamlit_app.py

## Flujo implementado

### 1. Ingestión
Se cargó `raw_economic_data.csv` a la tabla:
`WAGES_CPI.RAW.ECONOMIC_DATA`

### 2. Transformación
Se crearon las tablas:
- `WAGES_CPI.ANALYTICS.MONTHLY_CPI_USA`
- `WAGES_CPI.ANALYTICS.ANNUAL_WAGES_CPI_USA`

### 3. Entrega
Se creó la app:
`wages_cpi_usa_app`

La app visualiza:
- CPI mensual USA
- salario promedio anual USA
- CPI promedio anual USA
- tablas de detalle

## Validaciones
- RAW.ECONOMIC_DATA = 30 filas
- ANALYTICS.MONTHLY_CPI_USA = 30 filas
- ANALYTICS.ANNUAL_WAGES_CPI_USA = 5 filas

## Aprendizajes
- creación de database y schemas
- uso de file format
- uso de stage
- carga de CSV a Snowflake
- transformación SQL
- visualización con Streamlit en Snowflake

## Nota
El dataset original del curso no estuvo disponible en Marketplace, así que se sustituyó por un CSV propio para replicar el pipeline.