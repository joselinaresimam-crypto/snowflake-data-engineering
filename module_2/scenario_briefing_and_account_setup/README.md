# Scenario briefing and account setup

## Objetivo
Preparar la cuenta de Snowflake para el caso práctico del curso cargando el dataset **Tasty Bytes** y dejar documentado el proceso completo de ejecución **desde VS Code usando Snowflake CLI**, manteniendo una forma de trabajo más cercana a un entorno real de data engineering.

---

## Contexto de la lección
En esta lección el curso plantea un escenario ficticio donde trabajamos como **Data Engineer** para el equipo de **Tasty Bytes**, una empresa de food trucks con presencia global.

El objetivo de negocio es ayudar a analistas que monitorean el desempeño de ventas de los food trucks y que, en este caso, tienen dudas sobre el rendimiento de un food truck en **Hamburg, Germany**.

Para poder seguir el resto del curso, primero era necesario cargar en Snowflake toda la información base del caso en una base de datos llamada:

```sql
TASTY_BYTES
```

Esta carga inicial es fundamental porque el resto de los ejercicios del curso dependen de que estos datos ya existan dentro de la cuenta.

---

## Qué pedía el curso originalmente
El curso indica este flujo:

1. Ubicar el archivo `load_tasty_bytes.sql` en el repositorio base `modern-data-engineering-snowflake`.
2. Copiar el contenido del archivo.
3. Ir a **Snowsight**.
4. Crear un SQL Worksheet.
5. Pegar el script.
6. Usar la opción **Run all**.
7. Esperar a que termine la ejecución.
8. Validar que la base `TASTY_BYTES` se haya creado correctamente.

---

## Cómo lo hicimos nosotros
Aunque el curso propone ejecutar el script desde **Snowsight**, en este proyecto se prioriza trabajar desde **VS Code** para desarrollar hábitos más alineados con un entorno real de ingeniería de datos.

Por eso, en lugar de ejecutar esta lección desde la interfaz web, realizamos la carga usando **Snowflake CLI** desde la terminal de VS Code.

### ¿Qué es un CLI?
**CLI** significa **Command Line Interface**.

Es una interfaz basada en terminal que permite ejecutar comandos y scripts sin depender de una interfaz gráfica.

En el contexto de Snowflake, el CLI permite:

- conectarse a una cuenta de Snowflake desde la terminal
- ejecutar archivos SQL completos
- automatizar procesos
- versionar mejor el trabajo dentro del repositorio
- trabajar de una forma más parecida a un flujo real de data engineering

---

## Estructura de trabajo utilizada
Dentro del repositorio principal se organizó la lección así:

```text
module_2/
└── scenario_briefing_and_account_setup/
    ├── sql/
    │   ├── 01_load_tasty_bytes.sql
    │   └── 02_validations_load_tasty_bytes.sql
    ├── notes.md
    └── README.md
```

### Propósito de cada archivo
- `01_load_tasty_bytes.sql`: script principal de carga del dataset Tasty Bytes.
- `02_validations_load_tasty_bytes.sql`: script de validaciones posteriores a la carga.
- `notes.md`: notas técnicas de la lección.
- `README.md`: documentación final para GitHub.

---

## Revisión del script antes de ejecutarlo
Antes de correr el archivo, se revisó su estructura para entender qué estaba haciendo internamente.

El script realiza, en términos generales, cinco tareas principales:

### 1. Creación de infraestructura básica
- usa el rol `ACCOUNTADMIN`
- crea la base de datos `TASTY_BYTES`
- crea varios schemas para separar capas de información
- crea un warehouse temporal para la carga

### 2. Definición del formato y stage
- crea un **file format** para archivos CSV
- crea un **stage** apuntando a archivos almacenados en S3

### 3. Construcción de la capa raw
Crea tablas base para:
- `country`
- `franchise`
- `location`
- `menu`
- `truck`
- `order_header`
- `order_detail`
- `customer_loyalty`

### 4. Construcción de capas de consumo
Crea vistas en:
- `HARMONIZED`
- `ANALYTICS`

Estas vistas integran y exponen la información para análisis posteriores.

### 5. Carga de datos con `COPY INTO`
Carga datos desde S3 hacia las tablas raw usando sentencias `COPY INTO`.

---

## Ajuste realizado antes de ejecutar
El script original traía el warehouse de carga con tamaño `XLARGE`:

```sql
WAREHOUSE_SIZE = 'xlarge'
```

Para evitar problemas potenciales en una cuenta trial y no consumir recursos innecesarios, se ajustó a:

```sql
WAREHOUSE_SIZE = 'small'
```

Este cambio no afecta el objetivo de aprendizaje de la lección. Solo hace la ejecución más práctica para este entorno.

---

## Paso a paso de lo que hicimos

### Paso 1. Ubicar el archivo del curso
Se localizó el archivo `load_tasty_bytes.sql` dentro del repositorio base del curso:

```text
modern-data-engineering-snowflake/module-2/
```

### Paso 2. Copiarlo al repositorio práctico
Se guardó dentro del proyecto principal con nombre ordenado:

```text
module_2/scenario_briefing_and_account_setup/sql/01_load_tasty_bytes.sql
```

### Paso 3. Revisar su contenido
Se analizó el script para entender:
- qué objetos creaba
- qué capas construía
- cómo cargaba los datos
- qué patrones de Snowflake reutilizaba

### Paso 4. Ajustar el tamaño del warehouse
Se cambió `XLARGE` por `SMALL`.

### Paso 5. Revisar la conexión de Snowflake CLI
Se intentó primero:

```powershell
snow connection test
```

Eso falló porque no existía una conexión configurada como `default`.

Después se listaron las conexiones disponibles:

```powershell
snow connection list
```

Y se identificó la conexión correcta:

```text
modern_data_engineering_snowflake
```

### Paso 6. Probar la conexión correcta
Se probó la conexión explícitamente con:

```powershell
snow connection test -c modern_data_engineering_snowflake
```

### Paso 7. Ejecutar el script completo desde VS Code
Ya con la conexión identificada, se ejecutó el archivo SQL completo desde la terminal:

```powershell
snow sql -c modern_data_engineering_snowflake -f module_2\scenario_briefing_and_account_setup\sql\01_load_tasty_bytes.sql
```

### Paso 8. Confirmar la ejecución
La salida mostró que las sentencias `COPY INTO` cargaron archivos correctamente y al final el warehouse temporal se eliminó con éxito:

```sql
DROP WAREHOUSE demo_build_wh;
```

Esto confirmó que el script se ejecutó de principio a fin.

---

## Qué construyó realmente este script
Esta parte es importante porque aquí ya se empieza a ver una lógica real de data engineering.

### Base de datos
- `TASTY_BYTES`

### Schemas creados
- `RAW_POS`
- `RAW_CUSTOMER`
- `HARMONIZED`
- `ANALYTICS`
- `PUBLIC`

### Warehouse temporal
- `DEMO_BUILD_WH`

### Stage y file format
- `TASTY_BYTES.PUBLIC.CSV_FF`
- `TASTY_BYTES.PUBLIC.S3LOAD`

### Tablas raw
- `COUNTRY`
- `FRANCHISE`
- `LOCATION`
- `MENU`
- `TRUCK`
- `ORDER_HEADER`
- `ORDER_DETAIL`
- `CUSTOMER_LOYALTY`

### Vistas creadas
#### En `HARMONIZED`
- `ORDERS_V`
- `CUSTOMER_LOYALTY_METRICS_V`

#### En `ANALYTICS`
- `ORDERS_V`
- `CUSTOMER_LOYALTY_METRICS_V`

---

## Explicación técnica de la arquitectura
El script refleja una arquitectura por capas muy común en data engineering.

### Capa raw
Es la zona donde se cargan los datos lo más cerca posible a su forma original.

En este caso:
- ventas
- clientes
- ubicación
- menú
- food trucks

Esta capa sirve como punto base para transformaciones posteriores.

### Capa harmonized
Aquí se integran varias tablas mediante joins para ofrecer una vista más útil y coherente del negocio.

Por ejemplo, la vista `harmonized.orders_v` reúne información de pedidos, menú, truck, franquicia, ubicación y cliente.

### Capa analytics
Aquí se exponen vistas listas para análisis, consumo por dashboards o exploración de negocio.

Esto se parece mucho a lo que después consumirían:
- analistas
- dashboards
- modelos analíticos
- herramientas BI

---

## Validaciones realizadas después de la carga
Después de ejecutar el script principal, se creó un segundo archivo de validaciones:

```text
02_validations_load_tasty_bytes.sql
```

El objetivo fue verificar que la carga no solo terminara sin error, sino que realmente hubiera dejado los objetos y datos esperados.

### Validación 1. Existencia de la base y schemas
Se validó que existiera la base `TASTY_BYTES` y sus schemas principales.

### Validación 2. Conteo por tabla
Se hizo un conteo de registros por cada tabla relevante.

### Resultados observados
Los conteos obtenidos mostraron datos cargados correctamente en todas las tablas principales:

| Tabla | Registros |
|---|---:|
| country | 30 |
| customer_loyalty | 222540 |
| franchise | 335 |
| location | 13093 |
| menu | 100 |
| order_detail | 55968589 |
| order_header | 20671294 |
| truck | 450 |

Estos resultados son consistentes con una carga masiva exitosa.

### Validación 3. Vistas harmonized y analytics
También se verificó que las vistas existieran y devolvieran resultados.

### Validación 4. Caso funcional de Hamburg, Germany
Se probó una consulta específica para buscar registros relacionados con:

- `primary_city = 'HAMBURG'`
- `country = 'GERMANY'`

La consulta no devolvió resultados.

### Interpretación correcta de ese resultado
Esto **no implica error en la carga**.

Más bien indica una de estas posibilidades:
- no existen registros exactos con esa combinación
- los valores pueden estar almacenados con otra variante de nombre
- el filtro exacto con `=` puede ser demasiado estricto

Este hallazgo es útil porque refleja un comportamiento real de datos operativos: los valores textuales no siempre están estandarizados como uno espera.

---

## Qué aprendimos en esta lección

### 1. El setup inicial de datos también es parte del trabajo de ingeniería
Antes de construir pipelines, dashboards o transformaciones, primero hay que preparar el entorno de datos.

### 2. Snowflake puede leer datos externos directamente desde S3
No fue necesario descargar archivos manualmente. Snowflake accedió a ellos mediante un `STAGE`.

### 3. `COPY INTO` sigue siendo una pieza central
Este comando es clave para carga batch en Snowflake.

### 4. La organización por capas no es teoría, se ve en la práctica
El script ya nos mostró una arquitectura con capas `raw`, `harmonized` y `analytics`.

### 5. Ejecutar desde CLI da más control
Trabajar desde terminal permite repetir, versionar y documentar mejor el proceso.

### 6. Validar después de correr es obligatorio
Que un script termine sin error no basta. También se debe validar existencia de objetos y volumen de datos.

---

## Cómo se habría ejecutado en Snowsight
Aunque en esta práctica se ejecutó desde CLI, el curso originalmente lo plantea así:

1. abrir Snowsight
2. crear un worksheet SQL
3. pegar el contenido del archivo
4. usar **Run all**
5. esperar a que termine
6. refrescar el object explorer si la base no aparece de inmediato

---

## Cómo lo ejecutamos nosotros desde VS Code

### Comando principal
```powershell
snow sql -c modern_data_engineering_snowflake -f module_2\scenario_briefing_and_account_setup\sql\01_load_tasty_bytes.sql
```

### Ventajas de este enfoque
- queda trazabilidad del archivo ejecutado
- el script vive dentro del repositorio
- facilita repetir el proceso
- se alinea mejor con prácticas reales de data engineering
- permite documentar exactamente qué se corrió

---

## Resultado final de la lección
La lección quedó completada correctamente.

### Estado final
- dataset Tasty Bytes cargado en Snowflake
- base `TASTY_BYTES` creada
- tablas raw cargadas
- vistas harmonized y analytics disponibles
- validaciones satisfactorias
- proceso documentado desde VS Code con Snowflake CLI

---

## Conexión con data engineering real
Esta lección, aunque parece de preparación, en realidad refleja varias tareas reales de un Data Engineer:

- preparar ambientes de datos
- ejecutar scripts reproducibles
- crear objetos de almacenamiento y cómputo
- leer archivos desde almacenamiento externo
- cargar datos batch
- validar resultados posteriores a la carga
- documentar el proceso de forma clara y reutilizable

---

## Archivos de esta lección
- `sql/01_load_tasty_bytes.sql`
- `sql/02_validations_load_tasty_bytes.sql`
- `notes.md`
- `README.md`

---

## Siguiente paso
Con el entorno Tasty Bytes ya cargado, la cuenta queda lista para continuar con las siguientes lecciones del curso y trabajar sobre un caso consistente a lo largo del módulo.
