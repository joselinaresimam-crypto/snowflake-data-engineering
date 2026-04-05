# Notes - Stored Procedures en Snowflake (Nivel Profesional)

## ¿Qué es un Stored Procedure?

Un stored procedure en Snowflake es un objeto de base de datos que
encapsula lógica compleja reutilizable que puede ejecutarse bajo demanda
o de forma automatizada.

A diferencia de consultas SQL simples o UDFs, un stored procedure
permite:

-   Ejecutar múltiples operaciones en secuencia
-   Controlar flujo lógico (if, loops, etc.)
-   Leer y escribir tablas
-   Integrarse con otros objetos como streams y tasks
-   Ejecutar lógica en diferentes lenguajes (SQL, Python, JavaScript,
    etc.)

## Diferencia entre UDF vs Stored Procedure

  Característica       UDF                 Stored Procedure
  -------------------- ------------------- ----------------------------------
  Propósito            Cálculo puntual     Proceso completo
  Retorno              Escalar o tabular   Generalmente mensaje o resultado
  Complejidad          Baja                Alta
  Escritura de datos   ❌                  ✅
  Uso típico           Transformaciones    Orquestación

👉 En resumen: - UDF = función - Stored Procedure = proceso

## ¿Qué estamos haciendo en esta lección?

Estamos construyendo un flujo real de data engineering:

1.  Insertamos datos en una tabla (order_header)
2.  Un stream detecta cambios
3.  Un stored procedure:
    -   Lee el stream
    -   Filtra inserts
    -   Enriquese datos (join con location)
    -   Aplica lógica de negocio (Hamburg)
    -   Agrega datos
    -   Escribe resultados en una tabla destino

## ¿Qué es Snowpark?

Snowpark permite escribir lógica en Python (u otros lenguajes) pero
ejecutándose dentro del motor de Snowflake.

Esto significa: - No mueves los datos - Escalas automáticamente -
Combinas SQL + Python

## Concepto clave: Streams

Un stream en Snowflake:

-   Captura cambios (CDC)
-   Registra INSERT, UPDATE y DELETE
-   Permite procesamiento incremental

👉 Esto evita reprocesar toda la tabla.

## Alcances de Stored Procedures en Snowflake

Se pueden usar para:

-   Procesar pipelines batch
-   Ejecutar lógica incremental
-   Automatizar cargas
-   Crear procesos reutilizables
-   Integrarse con tasks (automatización)
-   Orquestar flujos de datos

## Buenas prácticas

-   Un procedimiento = un propósito claro
-   Separar lógica en pasos
-   Documentar cada bloque
-   Validar outputs
-   Evitar inconsistencias de tipos
-   Usar nombres claros (snake_case)
-   Manejar errores (try/catch en Python)
-   Evitar lógica innecesariamente compleja

## Mejoras aplicadas en esta lección

### Problemas en versión original:

-   Tipo de retorno inconsistente
-   Escritura de dataframe incorrecto
-   Código menos claro

### Solución aplicada:

-   Se corrigió tipo de retorno (str)
-   Se escribe dataframe correcto (daily_sales)
-   Se mejoró legibilidad
-   Se alineó con buenas prácticas

## ¿Por qué esto es importante?

Porque en producción: - estos procesos se automatizan - deben ser
confiables - deben ser mantenibles - deben escalar

## Conclusión

Stored procedures son el corazón de la lógica compleja en Snowflake y
una pieza clave en pipelines modernos de data engineering.
