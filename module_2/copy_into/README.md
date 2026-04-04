# Loading data using the COPY INTO command

## Objetivo
Aprender a cargar datos en Snowflake desde archivos ubicados en almacenamiento externo (AWS S3) utilizando el comando `COPY INTO`.

---

## ¿Qué es S3 y qué significa en este contexto?

S3 (Simple Storage Service) es un servicio de almacenamiento de objetos en la nube de AWS.

En términos simples:
- Es como un "Google Drive" o "Dropbox", pero para datos a gran escala.
- Permite almacenar archivos como CSV, JSON, Parquet, etc.
- Es muy usado en arquitecturas de datos modernas.

En esta lección:
- Los datos (archivo `menu.csv.gz`) ya están almacenados en un bucket público de S3.
- Snowflake no tiene el archivo dentro directamente.
- En lugar de eso, Snowflake **accede al archivo a través de una referencia (URL)**.

👉 Es decir:  
No descargamos el archivo manualmente.  
Snowflake lo lee directamente desde S3.

---

## ¿Qué hicimos realmente?

Construimos un flujo de carga de datos desde almacenamiento externo hacia Snowflake.

### Flujo completo:

```text
Archivo en S3 (menu.csv.gz)
        ↓
Stage externo (blob_stage)
        ↓
COPY INTO
        ↓
Tabla en Snowflake (sample_menu_copy_into)
```

---

## Paso a paso

### 1. Crear la tabla destino
Se define la estructura donde se cargarán los datos.

Archivo:  
`01_create_sample_menu_table.sql`

---

### 2. Crear el stage externo
Se crea un objeto en Snowflake que apunta a la ubicación del archivo en S3.

Archivo:  
`02_create_blob_stage.sql`

Ejemplo:
```sql
CREATE STAGE blob_stage
URL = 's3://sfquickstarts/tastybytes/'
FILE_FORMAT = (TYPE = CSV);
```

📌 Importante:
- El stage **no guarda los datos**, solo guarda la referencia al origen.
- En este caso, el bucket es público, por eso no usamos credenciales.

---

### 3. Listar archivos del stage
Se verifica que Snowflake puede ver los archivos en S3.

Archivo:  
`03_list_stage_files.sql`

---

### 4. Ejecutar COPY INTO
Se cargan los datos desde el archivo en S3 hacia la tabla en Snowflake.

Archivo:  
`04_copy_into_sample_menu.sql`

Ejemplo:
```sql
COPY INTO sample_menu_copy_into
FROM @blob_stage/raw_pos/menu/;
```

📌 Aquí ocurre la magia:
- Snowflake lee el archivo directamente desde S3
- Interpreta el formato (CSV)
- Inserta los datos en la tabla

---

### 5. Validar la carga
Se consulta la tabla para verificar que los datos se cargaron correctamente.

Archivo:  
`05_validate_sample_menu.sql`

Resultado esperado:
- 100 filas cargadas

---

## Conceptos clave

### 🔹 Stage
Objeto en Snowflake que referencia archivos externos o internos.

Tipos:
- Interno → dentro de Snowflake
- Externo → S3, Azure Blob, GCS

---

### 🔹 COPY INTO
Comando principal de carga batch en Snowflake.

Permite:
- Cargar grandes volúmenes de datos
- Leer desde stages
- Manejar errores (`ON_ERROR`)
- Trabajar con distintos formatos

---

### 🔹 File Format
Define cómo interpretar el archivo:

- Tipo (CSV, JSON, Parquet)
- Delimitador
- Encabezados
- Espacios
- Comillas

---

## ¿Por qué este patrón es importante?

Este es uno de los patrones más usados en data engineering:

```text
Cloud Storage → Stage → COPY INTO → Data Warehouse
```

Se usa para:
- Cargas masivas de datos
- Integración con pipelines
- Data lakes → data warehouse

---

## Aprendizaje clave

- Snowflake puede leer datos directamente desde la nube (S3)
- No es necesario mover archivos manualmente
- El stage actúa como puente entre almacenamiento y tabla
- `COPY INTO` es la base de ingestion batch
- Este flujo se automatiza después con herramientas como:
  - Snowpipe
  - Tasks
  - Streams

---

## Resultado final

- Archivo detectado: `menu.csv.gz`
- Filas cargadas: 100
- Tabla poblada correctamente: `sample_menu_copy_into`

---

## Conclusión

En esta lección se implementó un flujo real de ingestión de datos desde almacenamiento en la nube hacia Snowflake, utilizando uno de los mecanismos más utilizados en entornos productivos.

---
