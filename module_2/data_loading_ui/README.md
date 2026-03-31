# Módulo 2 - Carga de datos con la interfaz web de Snowflake

## Descripción
En esta sección se realiza la carga de un archivo local hacia Snowflake utilizando Snowsight, la interfaz web de Snowflake.

## Objetivo
Aprender a cargar datos de forma rápida y visual sin escribir el proceso completo en SQL, aprovechando la detección automática de formato y esquema que ofrece Snowflake.

## Archivo utilizado
- `sample_orders.csv`

## Ruta de trabajo
- `data/` → archivo fuente
- `sql/` → query de validación
- `screenshots/` → evidencias del proceso
- `README.md` → documentación de la práctica

## Pasos realizados
1. Entrar a Snowsight
2. Ir a **Data**
3. Seleccionar **Add Data**
4. Elegir **Load data into a table**
5. Subir el archivo `sample_orders.csv`
6. Crear la base de datos `LOAD_DATA`
7. Usar el schema `PUBLIC`
8. Crear la tabla `SAMPLE_ORDERS_UI`
9. Revisar el esquema inferido automáticamente por Snowflake
10. Ejecutar la carga
11. Validar la información con el script SQL

## Aprendizajes clave
- Snowflake permite cargar archivos locales directamente desde su interfaz web
- La plataforma puede detectar automáticamente el formato del archivo y el esquema de la tabla
- La interfaz permite revisar el SQL generado detrás del proceso
- Este método es útil para cargas rápidas, migraciones iniciales y pruebas

## Validación
Una vez cargados los datos en Snowsight, ejecutar el archivo:

- `sql/validation_queries.sql`

## Nota importante
Si el script de validación marca error de que la base de datos o la tabla no existen, primero debe realizarse la carga del archivo en la interfaz web de Snowflake.

## SQL generado por Snowflake
Durante la carga desde la interfaz web, Snowflake generó internamente sentencias SQL para:

- crear la tabla destino
- definir un file format temporal para el archivo CSV
- ejecutar la carga mediante `COPY INTO`

Esto permite entender que la interfaz web abstrae el proceso, pero sigue utilizando los mismos fundamentos SQL de ingestión.