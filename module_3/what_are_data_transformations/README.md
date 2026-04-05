# What are Data Transformations?

## 🎯 Objetivo

Entender qué son las transformaciones de datos dentro de un pipeline de
data engineering y por qué son esenciales para convertir datos crudos en
insights de negocio.

------------------------------------------------------------------------

## 🧠 Contexto

En la construcción de pipelines de datos, los datos en su estado
original (RAW) rara vez están listos para análisis. Es necesario aplicar
una serie de transformaciones para limpiarlos, estructurarlos y
enriquecerlos.

------------------------------------------------------------------------

## 🔍 ¿Qué son las Data Transformations?

Las transformaciones de datos son el conjunto de operaciones que se
realizan sobre los datos crudos para prepararlos para análisis o
consumo.

Incluyen: - Limpieza de datos - Cambio de formatos - Cálculos y
agregaciones - Creación de nuevas columnas - Generación de tablas
derivadas

------------------------------------------------------------------------

## ⚙️ Tipos de transformaciones

### 1. Limpieza de datos

``` sql
SELECT COALESCE(nombre, 'UNKNOWN') AS nombre FROM tabla;
```

### 2. Formateo

``` sql
SELECT TO_DATE(fecha_string, 'YYYY-MM-DD') AS fecha FROM tabla;
```

### 3. Enriquecimiento

``` sql
SELECT precio, precio * 1.16 AS precio_con_iva FROM tabla;
```

### 4. Agregaciones

``` sql
SELECT cliente_id, SUM(ventas) FROM tabla GROUP BY cliente_id;
```

### 5. Modelado

``` sql
CREATE TABLE resumen AS SELECT * FROM tabla;
```

------------------------------------------------------------------------

## 🧱 Arquitectura Medallion

Las transformaciones permiten mover los datos a través de diferentes
capas:

-   **RAW (Bronze):** Datos sin procesar
-   **HARMONIZED (Silver):** Datos limpios y estructurados
-   **ANALYTICS (Gold):** Datos listos para análisis

------------------------------------------------------------------------

## 🧠 Aplicación en el mundo real

En entornos como banca o BI: - Se transforman logs y transacciones - Se
crean métricas como KPIs - Se preparan datasets para dashboards

------------------------------------------------------------------------

## 🚀 Conclusión

Las transformaciones son el núcleo de cualquier pipeline de datos.
Permiten convertir datos desordenados en información útil para la toma
de decisiones.
