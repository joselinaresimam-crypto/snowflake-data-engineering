# Complex Procedural Logic with Stored Procedures (Snowflake)

## Objetivo

Implementar lógica compleja reutilizable en Snowflake mediante stored
procedures usando Snowpark Python, integrando streams para procesamiento
incremental.

------------------------------------------------------------------------

## Contexto

En esta lección evolucionamos de UDFs a stored procedures.

-   UDF → lógica simple
-   Stored Procedure → lógica compleja + orquestación

Esto es fundamental en pipelines reales.

------------------------------------------------------------------------

## Arquitectura

Tabla origen → Stream → Stored Procedure → Tabla destino

order_header → order_header_stream → process_order_headers_stream →
daily_sales_hamburg_t

------------------------------------------------------------------------

## Flujo paso a paso

1.  Insertar datos en order_header
2.  Stream detecta cambios
3.  Stored procedure procesa:
    -   Filtra inserts
    -   Join con location
    -   Filtra Hamburg
    -   Agrega ventas
    -   Escribe resultado
4.  Validar tabla destino

------------------------------------------------------------------------

## Código utilizado

Incluye: - Definición del stored procedure - Inserción de datos -
Ejecución - Validación

------------------------------------------------------------------------

## Resultados

-   Fecha: 2023-07-01
-   Total: 45.80

------------------------------------------------------------------------

## Diferencias: original vs mejorado

### Original

-   Inconsistencias en tipos
-   Escritura incorrecta
-   Menor claridad

### Mejorado

-   Código limpio
-   Consistencia de tipos
-   Escritura correcta
-   Mejor mantenibilidad

------------------------------------------------------------------------

## Buenas prácticas aplicadas

-   Separación de scripts
-   Documentación clara
-   Uso correcto de Snowpark
-   Procesamiento incremental
-   Código reutilizable

------------------------------------------------------------------------

## Aplicación en mundo real

Este patrón se usa para:

-   Pipelines batch incrementales
-   ETL/ELT moderno
-   Procesamiento de eventos
-   Métricas agregadas
-   Automatización con tasks

------------------------------------------------------------------------

## Aprendizajes clave

-   Stored procedures como capa lógica
-   Streams para eficiencia
-   Snowpark como puente Python-SQL
-   Importancia de diseño limpio

------------------------------------------------------------------------

## Conclusión

El uso de stored procedures junto con streams permite construir
pipelines escalables, eficientes y mantenibles en Snowflake.

Este enfoque es estándar en data engineering moderno.
