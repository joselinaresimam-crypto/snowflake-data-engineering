# 📦 Carga de datos usando Snowflake CLI

## 🎯 Objetivo

Cargar datos desde un archivo CSV local hacia una tabla en Snowflake utilizando **Snowflake CLI**, evitando el uso manual de la interfaz (Snowsight) y habilitando procesos automatizables.

---

## 🧱 Arquitectura del proceso

```text
Archivo local → Stage en Snowflake → Tabla en Snowflake
```

Este flujo separa claramente:

* **Origen**: archivo local (CSV)
* **Almacenamiento intermedio**: stage
* **Destino final**: tabla

---

## 📂 Estructura de archivos

* `sample_orders.csv` → archivo fuente con datos
* `load_from_cli_stage.sql` → script de creación de tabla y carga
* `validate_load_from_cli.sql` → queries de validación
* `README.md` → documentación del proceso

---

## ⚙️ Pasos realizados

### 1. Crear el stage en Snowflake

```bash
snow stage create snowflake_cli_stage -c modern_data_engineering_snowflake
```

🔹 Esto crea un espacio de almacenamiento intermedio en Snowflake.

---

### 2. Subir el archivo CSV al stage

```bash
snow stage copy sample_orders.csv @snowflake_cli_stage/ -c modern_data_engineering_snowflake
```

🔹 Sube el archivo desde tu máquina al stage.

---

### 3. Subir el script SQL al stage

```bash
snow stage copy load_from_cli_stage.sql @snowflake_cli_stage/ -c modern_data_engineering_snowflake
```

---

### 4. Ejecutar el SQL desde el stage

```bash
snow stage execute @snowflake_cli_stage/load_from_cli_stage.sql -c modern_data_engineering_snowflake
```

🔹 Este comando ejecuta el SQL directamente dentro de Snowflake.

---

### 5. Validar la carga

```sql
SELECT COUNT(*) AS total_registros
FROM load_data.public.sample_orders_cli;

SELECT *
FROM load_data.public.sample_orders_cli
LIMIT 10;
```

---

## 🧠 Conceptos clave

### 📌 ¿Qué es un stage?

Un **stage** es una ubicación de almacenamiento dentro de Snowflake donde se colocan archivos (CSV, JSON, etc.) antes de ser cargados a tablas.

👉 Funciona como una “zona intermedia” entre los datos crudos y las tablas estructuradas.

---

### 📌 Flujo real de ingestión

```text
Tu computadora → Stage → Tabla
```

* El archivo se sube primero al stage
* Luego se carga a la tabla con `COPY INTO`

---

### 📌 Diferencia entre subir y cargar

| Acción       | Qué hace                  |
| ------------ | ------------------------- |
| `stage copy` | Sube archivo al stage     |
| `COPY INTO`  | Inserta datos en la tabla |

---

### 📌 Ejecución del SQL

El comando:

```bash
snow stage execute ...
```

👉 Ejecuta el script dentro de Snowflake
👉 No es necesario volver a ejecutarlo en VS Code o Snowsight

---

## ⚠️ Consideraciones importantes

### 🔹 Rutas dentro del stage

Si defines mal el destino, puedes generar rutas como:

```text
sample_orders.csv/sample_orders.csv
```

Esto ocurre cuando el CLI interpreta el destino como carpeta + archivo.

✔ Solución:

```bash
@snowflake_cli_stage/
```

---

### 🔹 Re-ejecución del proceso

* Subir el archivo nuevamente **no duplica datos**
* La duplicación depende del SQL (`COPY INTO`)

En este caso:

```sql
CREATE OR REPLACE TABLE
```

👉 La tabla se reemplaza cada vez → no hay duplicados

---

### 🔹 Persistencia del stage

El stage:

* ✅ Es persistente
* ❌ No se borra al cerrar sesión
* ✅ Permanece hasta eliminarlo manualmente

---

### 🔹 Ubicación en Snowflake (Snowsight)

Puedes verlo en:

* Data → Database → Schema → **Stages**

---

## 🧹 Limpieza del stage

### Ver archivos

```sql
LIST @snowflake_cli_stage;
```

### Borrar archivo específico

```sql
REMOVE @snowflake_cli_stage/sample_orders.csv;
```

### Borrar todo

```sql
REMOVE @snowflake_cli_stage;
```

---

## 🚀 Ventajas del uso de CLI

* Automatización de procesos
* Evita pasos manuales en UI
* Integración con scripts (Python, Bash, PowerShell)
* Escalabilidad para cargas batch

---

## ⚠️ Limitaciones

* El stage no monitorea carpetas automáticamente
* No carga datos sin SQL (`COPY INTO`)
* Requiere control de rutas
* Puede volverse desordenado si no se limpia

---

## 🧠 Aprendizajes clave

* Separación clara entre almacenamiento y carga
* Importancia de rutas en stages
* Diferencia entre ingestión manual vs automatizada
* Uso de CLI como base para pipelines de datos

---

## 🏁 Conclusión

Se implementó exitosamente un flujo completo de ingestión:

```text
Archivo local → Stage → Tabla
```

Este proceso es la base para construir pipelines de datos automatizados en Snowflake.
