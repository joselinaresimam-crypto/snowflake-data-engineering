# Snowflake Marketplace - FROSTBYTE_WEATHERSOURCE

## Objetivo
Aprender a cargar datos desde Snowflake Marketplace sin necesidad de ingestión manual.

## Dataset utilizado
Weather Source LLC: frostbyte

## Pasos realizados
1. Acceder a Snowflake (Snowsight)
2. Navegar a Data Products → Marketplace
3. Buscar dataset
4. Cargarlo con nombre:
   FROSTBYTE_WEATHERSOURCE
5. Ejecutar queries exploratorias

## Aprendizajes clave
- No todos los datos se cargan manualmente
- Marketplace permite acceso a datasets mantenidos por terceros
- Se cargan como bases de datos compartidas (data share)

## Problema encontrado

Error:
"Cannot perform SELECT. This session does not have a current database."

## Solución

Se debe definir el contexto de trabajo:

```sql
USE DATABASE FROSTBYTE_WEATHERSOURCE;
USE SCHEMA ONPOINT_ID;

## Resultado de la práctica

Se logró cargar correctamente el dataset desde Snowflake Marketplace con el nombre `FROSTBYTE_WEATHERSOURCE`.

Posteriormente se configuró el contexto del worksheet al database `FROSTBYTE_WEATHERSOURCE` y al schema `ONPOINT_ID`, lo que permitió ejecutar queries sobre las vistas compartidas del proveedor.

Se ejecutó una consulta de ejemplo sobre `ONPOINT_ID.FORECAST_DAY`, obteniendo métricas climáticas proyectadas para el código postal `02201` en Estados Unidos para el siguiente fin de semana.

## Conclusión

Snowflake Marketplace permite consumir datasets externos ya mantenidos por un proveedor, sin necesidad de cargar archivos manualmente. Una vez agregado el data share a la cuenta, los objetos pueden consultarse con SQL dentro de Snowflake.





