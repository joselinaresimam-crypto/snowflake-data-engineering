# Notes - Dynamic Tables

## 🧠 Concepto clave

Una Dynamic Table es una tabla gestionada por Snowflake que:
- Ejecuta automáticamente una consulta
- Mantiene resultados actualizados
- Controla frescura con TARGET_LAG

---

## 🔍 Diferencias clave

### Tabla normal
- Datos manuales

### Vista
- No persiste datos

### Stream
- Detecta cambios

### Dynamic Table
- Mantiene resultado transformado

---

## ⏱ TARGET_LAG

Define el retraso permitido:
- '1 minute'
- '1 hour'
- '24 hours'

💡 Balance entre costo y frescura

---

## ⚙️ Internamente

Snowflake:
- Detecta dependencias
- Ejecuta refresh automático
- Usa warehouse asignado

---

## 📊 Caso implementado

Transformación:
- ORDER_HEADER + LOCATION
- Filtro: Hamburg, Germany
- Agrupación diaria
- SUM(ORDER_TOTAL)

---

## 🧪 Validación

Se insertaron registros dummy:
- Se confirmó actualización automática
- Se validó comportamiento de agregación

---

## ⚠️ Buenas prácticas

- Definir TARGET_LAG según negocio
- Usar warehouses adecuados
- Evitar lógica compleja en dynamic tables
- Documentar bien las transformaciones

---

## 🧩 Cuándo usar

✔ Agregaciones
✔ Capas analíticas
✔ Pipelines simples

---

## ❌ Cuándo NO usar

- Lógica compleja
- Manejo de deletes específicos
- Procesamiento incremental avanzado

---

## 🧠 Insight final

Dynamic Tables = enfoque declarativo  
Streams + SP = enfoque procedural

Ambos son necesarios como Data Engineer.
