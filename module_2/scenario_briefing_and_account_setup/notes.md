# Notes — Scenario Briefing and Account Setup (Tasty Bytes)

## 🧠 Arquitectura identificada

En esta lección se observa una arquitectura por capas muy cercana al enfoque conocido como **medallion architecture**.

Aunque el script no usa explícitamente los nombres bronze, silver y gold, la lógica sí sigue ese principio: separar los datos según su nivel de procesamiento y su propósito dentro de la plataforma.

### ¿Qué es medallion architecture?

La arquitectura medallion es una forma de organizar datos en capas para evitar mezclar datos crudos, datos transformados y datos listos para negocio en un mismo lugar.

Normalmente se expresa así:

- **Bronze** → datos crudos
- **Silver** → datos depurados, integrados y armonizados
- **Gold** → datos listos para análisis, métricas y consumo de negocio

Su valor principal es que permite construir pipelines más claros, mantenibles y auditables.

En términos prácticos, esta arquitectura ayuda a responder preguntas como:

- ¿Dónde está el dato original?
- ¿Dónde está el dato ya integrado con otras fuentes?
- ¿Dónde está el dato listo para dashboards o analistas?

Sin esta separación, los entornos de datos tienden a volverse confusos, difíciles de depurar y riesgosos para producción.

---

## 🧱 Cómo se refleja aquí: RAW, HARMONIZED y ANALYTICS

En el script de Tasty Bytes aparecen tres niveles muy claros:

- **RAW**
- **HARMONIZED**
- **ANALYTICS**

Aunque Snowflake aquí no les llama bronze, silver y gold, conceptualmente se parecen mucho.

### 1. RAW

Los schemas `raw_pos` y `raw_customer` representan la capa más cercana al dato original.

Aquí se cargan tablas como:

- country
- franchise
- location
- menu
- truck
- order_header
- order_detail
- customer_loyalty

#### ¿Qué significa RAW?

RAW significa que el dato está en su forma más base o más cercana a como fue recibido desde la fuente.

En esta lección, esos datos vienen desde archivos en S3 y se cargan con `COPY INTO`.

#### ¿Para qué sirve mantener una capa RAW?

Porque permite:

- conservar el dato original
- volver a procesar transformaciones si algo cambia
- auditar de dónde salió un dato
- separar la ingestión de la transformación

#### ¿Por qué es importante?

Si mezclas lógica de negocio directamente sobre los datos recién cargados, pierdes trazabilidad y haces más difícil corregir errores.

La capa RAW funciona como el punto de aterrizaje inicial del pipeline.

---

### 2. HARMONIZED

La capa `harmonized` contiene vistas que integran varias tablas RAW para formar entidades más útiles.

Ejemplo claro:

- `orders_v`
- `customer_loyalty_metrics_v`

Aquí ya no se trata solo de almacenar datos, sino de **conectar piezas relacionadas**.

Por ejemplo, en `orders_v` se unen:

- order_detail
- order_header
- truck
- menu
- franchise
- location
- customer_loyalty

#### ¿Qué significa HARMONIZED?

HARMONIZED significa que los datos ya fueron organizados e integrados para que distintas entidades hablen el mismo idioma.

En otras palabras:
- ya no están aislados por tabla fuente
- ya tienen relaciones útiles
- ya están más listos para análisis

#### ¿Para qué sirve esta capa?

Sirve para:

- resolver joins complejos una sola vez
- centralizar lógica de integración
- evitar que cada analista rehaga las mismas uniones
- construir una vista más coherente del negocio

#### ¿Por qué es importante?

Porque en un entorno real, el negocio no piensa en tablas separadas como `order_header` y `order_detail`; piensa en órdenes, clientes, ventas, ubicaciones y desempeño.

La capa harmonized acerca los datos al lenguaje del negocio sin todavía convertirlos en reportes finales.

---

### 3. ANALYTICS

La capa `analytics` expone vistas listas para consumo analítico.

Aquí aparecen:

- `analytics.orders_v`
- `analytics.customer_loyalty_metrics_v`

Estas vistas se apoyan en `harmonized` y representan una capa más cercana a uso final.

#### ¿Qué significa ANALYTICS?

Significa que los datos ya están organizados para ser consumidos por:

- dashboards
- herramientas BI
- analistas
- consultas de negocio
- casos de exploración y reporting

#### ¿Para qué sirve esta capa?

Sirve para:

- simplificar el acceso al dato
- publicar datasets listos para análisis
- desacoplar al usuario final de la complejidad del modelo base
- estandarizar métricas y estructuras de consumo

#### ¿Por qué es importante?

Porque no conviene que usuarios de negocio trabajen directamente sobre tablas raw o joins complejos.

La capa analytics reduce fricción, reduce errores y acelera el consumo del dato.

---

## 🎯 ¿Por qué es importante trabajar así?

Separar RAW, HARMONIZED y ANALYTICS no es solo “orden bonito”. Tiene beneficios reales de ingeniería.

### 1. Trazabilidad

Puedes saber:
- qué dato llegó originalmente
- qué transformación se aplicó
- qué dataset terminó usando negocio

Eso ayuda muchísimo para auditoría, debugging y gobierno de datos.

### 2. Reprocesamiento

Si cambia una lógica de negocio, no necesitas volver a conseguir la fuente original; puedes reprocesar desde RAW.

### 3. Mantenibilidad

Cada capa tiene un propósito distinto:
- una ingiere
- otra integra
- otra publica

Eso vuelve el sistema más claro y escalable.

### 4. Reutilización

Una vez que una entidad está bien armonizada, puede servir para muchos casos de uso distintos.

### 5. Menor riesgo

Evitas que usuarios finales toquen datos crudos o lógica inestable.

### 6. Mejor comunicación entre equipos

Los engineers, analistas y stakeholders pueden entender mejor dónde vive cada cosa.

---

## ⚙️ Flujo del script

1. Creación de base de datos, schemas y warehouse
2. Definición del FILE FORMAT para CSV
3. Creación del STAGE apuntando a S3
4. Creación de tablas RAW
5. Creación de vistas HARMONIZED
6. Creación de vistas ANALYTICS
7. Ingesta de datos con `COPY INTO`
8. Eliminación del warehouse temporal

Esto convierte al script en algo más que una simple carga de datos: realmente construye un entorno analítico inicial.

---

## 📦 COPY INTO — comportamiento observado

Durante la ejecución se observó que Snowflake:

- cargó datos directamente desde S3
- procesó múltiples archivos dentro del stage
- reportó archivos cargados y filas procesadas
- usó un `FILE FORMAT` reutilizable
- permitió una carga batch bastante natural para grandes volúmenes

Esto refuerza que `COPY INTO` es uno de los mecanismos centrales de batch ingestion en Snowflake.

---

## ⚠️ Observaciones reales

En la validación funcional, el filtro exacto para Hamburg + Germany no devolvió resultados.

Eso no implica error de carga. Más bien deja una lección importante:

- los datos operativos pueden traer variaciones de texto
- la ciudad o país pueden no venir exactamente como se esperaba
- en escenarios reales conviene explorar catálogos antes de asumir coincidencias exactas

Buenas prácticas derivadas de este hallazgo:

- usar `ILIKE` para exploración inicial
- revisar `DISTINCT` de campos geográficos
- normalizar dimensiones de ciudad y país
- no depender siempre de filtros exactos con `=`

---

## 🧪 Validaciones realizadas

Se validó que:

- la base `TASTY_BYTES` se creó correctamente
- los schemas esperados existen
- las tablas RAW tienen registros
- las vistas HARMONIZED existen y responden
- las vistas ANALYTICS existen y responden
- la ingesta cargó millones de filas en tablas transaccionales grandes

Conteos observados:

- country → 30
- customer_loyalty → 222540
- franchise → 335
- location → 13093
- menu → 100
- order_detail → 55968589
- order_header → 20671294
- truck → 450

Estos volúmenes confirman que la carga fue exitosa y que el escenario del curso quedó correctamente preparado.

---

## 🧠 Aprendizajes técnicos

- Snowflake permite ingesta directa desde S3 mediante STAGE
- `COPY INTO` es el mecanismo principal para batch ingestion
- La separación por capas facilita el modelado y la gobernanza
- Un warehouse temporal puede usarse solo durante la carga para optimizar costos
- Las vistas permiten desacoplar la lógica de consumo del almacenamiento base
- Validar un pipeline no es solo revisar que “no falle”; también hay que comprobar estructura, volumen y consistencia

---

## 💡 Insight clave

La gran enseñanza de esta lección no es solo cómo cargar datos, sino cómo empezar a estructurar una plataforma analítica de forma ordenada.

Trabajar con capas como RAW, HARMONIZED y ANALYTICS permite construir soluciones más cercanas a un entorno real de data engineering, donde el orden, la trazabilidad y la reutilización del dato son tan importantes como la carga misma.
