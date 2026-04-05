# Notes técnicas - Streams en Snowflake

## 1. Definición técnica
Snowflake documenta un stream como un objeto que registra cambios DML en una tabla, vista, external table, dynamic table u otros objetos soportados. Esos cambios incluyen `INSERT`, `UPDATE` y `DELETE`, más metadata útil para interpretar cada cambio. Snowflake lo presenta como una capacidad de **Change Data Capture (CDC)**. citeturn412615search14turn412615search1

---

## 2. Cómo pensar un stream correctamente
No pensar en el stream como una “tabla donde se guardan todas las modificaciones para siempre”.

Pensarlo mejor así:
- la tabla base es la fuente real
- el stream guarda un **offset**
- al consultar el stream obtienes el delta entre dos puntos de tiempo transaccionales
- Snowflake reconstruye el resultado con columnas de la tabla fuente + columnas metadata

Snowflake lo explica explícitamente: el stream almacena un offset, no una copia física del contenido total. citeturn412615search5turn412615search1

---

## 3. Metadata importante observada
En la práctica vimos estas columnas:

### `METADATA$ACTION`
Indica la acción DML capturada, como `INSERT` o `DELETE`.

### `METADATA$ISUPDATE`
Indica si el cambio formó parte de un `UPDATE`. Snowflake explica que un update puede representarse como un par de registros `DELETE` + `INSERT` con esta metadata marcada en consecuencia. citeturn412615search5turn412615search1

### `METADATA$ROW_ID`
Identificador de la fila rastreada por el stream.

---

## 4. Diferencia entre “fecha” y “cambio”
Este punto es esencial.

### Fecha
Sirve para saber cuándo ocurrió un evento de negocio.

### Cambio
Sirve para saber cuándo se insertó, corrigió o eliminó una fila en la tabla.

Ejemplo:
- una venta ocurrió en enero 2023
- la corrección de esa venta se hizo en abril 2026

Si filtras por fecha del negocio, puedes no capturar la corrección.  
Si trabajas con stream, sí capturas el cambio actual.

---

## 5. Valor real en incremental processing
Los streams son útiles cuando queremos evitar full refreshes.

### Full refresh
```sql
SELECT DATE(order_ts), SUM(order_total)
FROM raw_pos.order_header
GROUP BY 1;
```

### Incremental con stream
```sql
SELECT *
FROM raw_pos.order_header_stream;
```

Luego puedes aplicar lógica incremental solo sobre las filas afectadas.

---

## 6. Relación con CDC
CDC = Change Data Capture.

Objetivo:
- detectar altas
- detectar bajas
- detectar modificaciones
- mover o procesar solo ese delta

Snowflake usa streams precisamente para este patrón. citeturn412615search1turn412615search3

---

## 7. Sobre el comportamiento del DELETE en la práctica
En la prueba del curso:
- insertamos una fila
- consultamos el stream
- borramos la fila
- volvimos a consultar

El comportamiento observado ayuda a entender que un standard stream no debe pensarse como una bitácora eterna de auditoría. La semántica correcta es la de cambios entre offsets transaccionales. Por eso la lección advierte que el delete no se verá “como intuitivamente esperaríamos”.

---

## 8. Escalamiento
Streams son especialmente valiosos cuando:
- la tabla fuente crece mucho
- hay refreshes frecuentes
- se necesita reducir costo
- los cambios diarios representan solo una fracción del total
- existen correcciones históricas

En esos casos, procesar solo el delta suele ser mucho más razonable que recalcular siempre todo.

---

## 9. Streams + Stored Procedures
Patrón útil:
1. stream detecta cambios
2. procedure implementa lógica
3. procedure actualiza tablas destino

Esto ayuda cuando el procesamiento incremental requiere varias reglas o pasos intermedios.

---

## 10. Streams + Tasks
Snowflake documenta streams y tasks como base para pipelines continuos. Una task puede ejecutar SQL o una procedure automáticamente en intervalos definidos o con dependencias entre tareas. citeturn412615search3turn412615search17

Patrón:
- llegan cambios
- stream los expone
- task corre
- analytics se actualiza

---

## 11. Streams + Dynamic Tables
Snowflake documenta que las dynamic tables mantienen datos transformados actualizados según una query y una política de freshness. También documenta que se pueden crear streams sobre dynamic tables incrementales, con limitaciones. citeturn412615search2turn412615search0

Esto abre opciones de arquitectura como:
- dynamic table para mantener una capa transformada
- stream sobre esa dynamic table para exponer deltas downstream

---

## 12. Buenas prácticas de diseño
- separar scripts por propósito
- entender el consumo del stream antes de automatizar
- no sustituir CDC con un simple filtro por fecha
- usar streams cuando haya valor claro en incrementalidad
- documentar claramente qué objeto consume el stream y con qué frecuencia
- pensar desde temprano cómo se conectará con procedures, tasks o capas analíticas

---

## 13. Qué deja esta lección
Esta lección marca un cambio importante de nivel:
- antes transformábamos datasets completos
- ahora empezamos a pensar en **pipelines incrementales**

Ese cambio es fundamental para trabajar como data engineer en escenarios reales dentro de Snowflake.
