# Notes - Data Transformations (Nivel Pro)

## 🧠 Concepto clave

Las transformaciones son el paso intermedio entre ingestión y análisis
dentro de un pipeline de datos.

RAW → TRANSFORM → INSIGHT

------------------------------------------------------------------------

## ⚙️ En Snowflake

Se pueden realizar transformaciones mediante:

-   SQL (principal herramienta)
-   Snowpark (Python, Java, Scala)
-   UDFs (funciones personalizadas)
-   Stored Procedures
-   Streams (procesamiento incremental)
-   Dynamic Tables (automatización)

------------------------------------------------------------------------

## 🔥 Buenas prácticas

-   No modificar datos RAW
-   Versionar transformaciones
-   Usar naming claro en tablas
-   Separar capas (Bronze, Silver, Gold)

------------------------------------------------------------------------

## 🧠 Pensamiento de Data Engineer

Un data engineer no solo transforma datos: - Diseña pipelines
escalables - Asegura calidad de datos - Optimiza performance -
Automatiza procesos

------------------------------------------------------------------------

## ⚡ Insight clave

Las transformaciones son donde vive la lógica de negocio. Si están mal
definidas → decisiones incorrectas.

------------------------------------------------------------------------

## 🚀 Nivel Pro

-   Usar streams para cambios incrementales
-   Implementar dynamic tables para automatización
-   Diseñar pipelines idempotentes
