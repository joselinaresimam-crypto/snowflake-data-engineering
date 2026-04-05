# Efficient Transformations with Streams

## Objetivo de la lección
Entender qué es un **stream** en Snowflake, por qué es importante para hacer transformaciones eficientes, y cómo se conecta con patrones reales de data engineering como **CDC**, **stored procedures**, **tasks** y **dynamic tables**.

---

## Contexto

Hasta esta lección, las transformaciones del curso habían trabajado sobre conjuntos completos de datos. Eso funciona para aprender, pero en escenarios reales no siempre es eficiente.

Ejemplo: si una tabla tiene 20 millones de registros y hoy solo cambiaron 1,000, no siempre conviene recalcular todo. Ahí entra el valor de **streams**: permiten trabajar sobre **cambios incrementales** en lugar de reprocesar la tabla completa.

Snowflake define un stream como un objeto que registra cambios de tipo DML sobre una tabla o vista, incluyendo `INSERT`, `UPDATE` y `DELETE`, junto con metadatos de esos cambios. Snowflake presenta esto como una capacidad de **Change Data Capture (CDC)**. Además, Snowflake explica que un stream funciona como una “change table” lógica que expone lo que cambió entre dos puntos transaccionales de tiempo. citeturn412615search1turn412615search14

---

## ¿Qué es un stream en palabras simples?

Una forma práctica de entenderlo es esta:

- La **tabla origen** sigue siendo la tabla real.
- El **stream** no es otra copia de la tabla.
- El stream actúa como una **ventana de cambios** sobre esa tabla.
- Cuando consultas el stream, no estás viendo “toda la tabla”, sino **solo las filas que cambiaron** desde cierto punto de referencia.

Snowflake documenta que un stream almacena un **offset** sobre el objeto fuente, no una copia física de todas las columnas o todos los datos. Al consultarlo, te devuelve los datos del objeto fuente con el mismo shape, más columnas de metadata para interpretar el cambio. citeturn412615search1turn412615search5

---

## ¿Para qué sirve realmente?

Aquí está la diferencia importante:

### Sin streams
Un pipeline incremental muchas veces se intenta resolver con filtros como:

```sql
SELECT *
FROM order_header
WHERE order_ts >= CURRENT_DATE - 1;
```

Eso puede parecer suficiente, pero tiene limitaciones:

- depende de que la fecha esté bien poblada
- falla si llega información atrasada
- puede no detectar correcciones sobre registros viejos
- si escaneas la tabla completa todos los días, pagas más cómputo
- si hubo `UPDATE` o `DELETE`, un filtro por fecha no siempre representa bien el cambio real

### Con streams
Un stream ya te entrega los cambios detectados por Snowflake:

```sql
SELECT *
FROM tasty_bytes.raw_pos.order_header_stream;
```

Eso permite diseñar pipelines que procesen **solo lo que cambió**.

---

## Un ejemplo importante: cambios sobre fechas viejas

Este fue uno de los aprendizajes más importantes de la lección.

Supongamos que en abril de 2026 llega una corrección sobre una venta que realmente ocurrió en enero de 2023.

Si tu pipeline depende solo de una lógica como:

```sql
WHERE order_ts >= '2026-04-01'
```

esa corrección de enero de 2023 podría no entrar, porque el valor de negocio del registro es viejo.

Con un stream, en cambio, no importa tanto si el dato de negocio es de 2023 o 2026. Lo importante es que **el registro cambió ahora**. Y eso sí queda capturado como cambio incremental.

Ese punto vuelve a los streams muy valiosos en escenarios reales donde:
- hay correcciones contables
- se ajustan pedidos históricos
- llegan datos tarde
- se reclasifican transacciones antiguas
- se corrigen dimensiones o atributos después del hecho

---

## Qué hicimos en esta lección

Tomamos el archivo base del curso y lo separamos en scripts más ordenados dentro del repo práctico.

### 1. Crear el stream
Creamos un stream sobre `tasty_bytes.raw_pos.order_header`:

```sql
CREATE OR REPLACE STREAM tasty_bytes.raw_pos.order_header_stream
ON TABLE tasty_bytes.raw_pos.order_header;
```

### 2. Insertar un registro dummy
Insertamos una fila de prueba para simular una nueva venta.

### 3. Consultar el stream
Consultamos el stream y vimos que el nuevo registro aparecía con columnas adicionales de metadata:

- `METADATA$ACTION`
- `METADATA$ISUPDATE`
- `METADATA$ROW_ID`

Snowflake documenta estas columnas y explica que:
- `METADATA$ACTION` indica la operación capturada (`INSERT` o `DELETE`)
- `METADATA$ISUPDATE` indica si ese cambio fue parte de un `UPDATE`
- `METADATA$ROW_ID` identifica de forma inmutable la fila fuente rastreada por el stream citeturn412615search5turn412615search1

### 4. Borrar el registro dummy
Después borramos la fila de prueba para no dejar basura en la tabla base.

### 5. Volver a consultar el stream
Aquí observamos un comportamiento muy importante: el stream no se comporta como una bitácora infinita y simple. El curso ya advertía que el `DELETE` no se iba a ver como intuitivamente podríamos pensar en un **standard stream**.

Este punto es clave porque obliga a entender que los streams no solo “guardan historial”; también tienen una semántica de **offset y consumo transaccional**. Snowflake lo explica como un mecanismo de CDC entre dos puntos transaccionales, no como una tabla audit eterna. citeturn412615search1turn412615search14

---

## ¿Entonces por qué no basta con usar una columna fecha?

Porque fecha y cambio real no son lo mismo.

### Una columna fecha te ayuda a:
- filtrar por periodo de negocio
- hacer reporting
- acotar ventanas de análisis

### Pero no garantiza:
- detectar correcciones de registros antiguos
- detectar deletes
- interpretar updates correctamente
- evitar lógica frágil basada en supuestos de tiempo

En otras palabras:

> **Fecha = lógica del negocio**  
> **Stream = lógica de cambios**

Y en pipelines reales muchas veces necesitas ambas cosas, pero cumplen funciones distintas.

---

## ¿Un INSERT reprocesa toda la tabla?

No.

Cuando insertas filas nuevas en la tabla origen, Snowflake solo inserta esas filas nuevas. El `INSERT` no recalcula automáticamente toda la tabla.

El reprocesamiento total aparece cuando tú diseñas lógica downstream como esta:

```sql
CREATE OR REPLACE TABLE daily_sales AS
SELECT DATE(order_ts) AS sales_date,
       SUM(order_total) AS total_sales
FROM order_header
GROUP BY 1;
```

Ese tipo de transformación sí recorre todo el dataset. Ahí es donde un stream se vuelve útil: puedes evitar full refreshes y trabajar solo con el delta.

---

## ¿Cómo alimenta tablas agregadas diarias?

Supongamos que tienes una tabla agregada:

```sql
analytics.daily_sales
```

### Sin streams
Cada día podrías recalcular todo:

```sql
INSERT INTO analytics.daily_sales
SELECT DATE(order_ts), SUM(order_total)
FROM raw_pos.order_header
GROUP BY 1;
```

Problemas:
- vuelves a leer mucho volumen
- pagas más cómputo
- el pipeline crece mal si la tabla base crece mucho

### Con streams
Puedes consultar solo los cambios nuevos o modificados y luego:
- sumar esos incrementos a la tabla agregada
- corregir días afectados
- ejecutar lógica incremental controlada

Esto es especialmente útil cuando:
- el volumen crece
- hay ventanas de refresh frecuentes
- necesitas eficiencia de cómputo
- quieres preparar pipelines más escalables

---

## ¿Qué es CDC?

CDC significa **Change Data Capture**.

Es un patrón de ingeniería de datos donde en vez de copiar o reprocesar todo, capturas y procesas **solo los cambios**:
- nuevos registros
- actualizaciones
- eliminaciones

Snowflake documenta explícitamente streams como un mecanismo para CDC. citeturn412615search1turn412615search3

### Por qué CDC importa
CDC ayuda a:
- reducir costo
- disminuir tiempos de procesamiento
- mover datos más rápido entre capas
- mantener sistemas analíticos más sincronizados
- hacer pipelines incrementales más robustos

---

## Streams y escalamiento

Aquí está uno de los mayores beneficios reales.

Cuando la tabla es pequeña, un full refresh diario puede no doler mucho.

Pero cuando la tabla:
- tiene millones de filas
- recibe cambios frecuentes
- alimenta métricas diarias, horarias o casi en tiempo real
- forma parte de un pipeline de varias capas

entonces el costo de recalcular todo empieza a crecer.

### Streams ayudan a escalar porque:
- limitan el procesamiento al delta
- reducen el volumen leído
- permiten pipelines más rápidos
- vuelven más razonable el uso del warehouse
- hacen más viable automatizar transformaciones frecuentes

No resuelven todo por sí solos, pero sí son una pieza muy poderosa para escalar transformación incremental.

---

## Streams + Stored Procedures

No es obligatorio usar streams con stored procedures, pero juntos hacen una combinación muy poderosa.

### Stream
Detecta qué cambió.

### Stored Procedure
Define qué hacer con esos cambios.

Ejemplo conceptual:
1. llegan cambios a `raw_pos.order_header`
2. el stream los expone
3. una stored procedure los lee
4. la procedure actualiza tablas agregadas, tablas harmonized o métricas analíticas

Este patrón es útil cuando:
- la lógica ya no cabe cómodamente en un solo SQL simple
- necesitas validaciones
- requieres control procedural
- debes manejar varios pasos de negocio

---

## Streams + Tasks + Dynamic Tables

Este fue otro punto clave para entender el valor de streams en arquitectura moderna.

Snowflake documenta streams y tasks como una forma de construir pipelines continuos. Además, documenta que las dynamic tables automatizan refreshes de transformación con una query definida y target freshness. Snowflake también indica que es posible crear streams sobre dynamic tables incrementales, con ciertas limitaciones. citeturn412615search3turn412615search2turn412615search0

### Pattern 1: Stream + Task
- el stream detecta el cambio
- una task corre cada cierto tiempo
- la task ejecuta SQL o procedure
- la tabla destino se actualiza automáticamente

### Pattern 2: Stream + Stored Procedure + Task
- stream = delta
- procedure = lógica
- task = automatización

### Pattern 3: Dynamic Tables
Las dynamic tables sirven para mantener transformaciones actualizadas automáticamente según una query y un target lag. En algunos casos pueden simplificar pipelines que antes requerían más orquestación manual. citeturn412615search2turn412615search9

### Cómo se conectan conceptualmente
Un pipeline típico podría verse así:

```text
raw table
   ↓
stream
   ↓
stored procedure
   ↓
task programada
   ↓
tabla harmonized / analytics
```

O bien:

```text
raw table
   ↓
dynamic table incremental
   ↓
stream sobre dynamic table
   ↓
consumidor downstream
```

Esto muestra que streams no son “solo para ver filas nuevas”, sino una base para arquitecturas incrementales más serias.

---

## Buenas prácticas aprendidas

### 1. No pensar en streams como “otra tabla”
Un stream no es una tabla espejo. Es una forma de exponer cambios.

### 2. No depender únicamente de fechas
Las fechas sirven, pero no reemplazan la lógica de CDC.

### 3. Separar scripts por propósito
En esta lección mantuvimos:
- creación
- prueba
- validación

Eso ayuda a ejecutar, depurar y documentar mejor.

### 4. Entender el comportamiento del stream antes de automatizar
Antes de conectar streams con procedures o tasks, primero hay que entender cómo se consulta y cómo se consumen los cambios.

### 5. Pensar en incrementalidad desde diseño
No esperar a que una tabla “ya sea muy grande” para considerar una estrategia incremental.

---

## Resultado obtenido en la práctica

Durante la prueba:
- creamos el stream sobre `order_header`
- insertamos una fila dummy
- confirmamos que el stream la detectó
- observamos metadata indicando que la acción fue `INSERT`
- eliminamos la fila de prueba
- validamos el comportamiento posterior del standard stream

Ese experimento simple fue suficiente para aterrizar un concepto muy poderoso: **Snowflake puede ayudarnos a trabajar sobre cambios y no solo sobre tablas completas**.

---

## Aprendizajes clave

1. Un stream en Snowflake registra cambios DML y expone una vista lógica del delta.
2. Su utilidad real no es “ver filas nuevas” por curiosidad, sino habilitar pipelines incrementales.
3. Un stream aporta más valor que un filtro por fecha cuando hay correcciones históricas, updates o deletes.
4. Es una pieza central para escenarios de CDC.
5. Se vuelve especialmente valioso cuando se combina con stored procedures, tasks y dynamic tables.
6. Este tema es importante porque ya nos acerca a patrones de data engineering de producción.

---

## Conexión con data engineering real

En entornos reales, muchas veces los equipos no quieren:
- recalcular millones de filas cada hora
- depender de filtros de fecha frágiles
- ignorar correcciones históricas
- construir pipelines lentos y costosos

Por eso los streams tienen tanto valor: son una herramienta concreta para diseñar transformaciones más eficientes, más robustas y más escalables dentro de Snowflake.

