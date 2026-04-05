# Automatic Transformations with Dynamic Tables

## 🎯 Objetivo
Implementar y entender el uso de Dynamic Tables en Snowflake para automatizar transformaciones de datos sin necesidad de streams, stored procedures o tasks.

---

## 📌 Contexto

En lecciones anteriores se trabajó con:
- Streams (para detectar cambios)
- Stored Procedures (para procesar cambios)
- Tasks (para automatizar ejecución)

En esta lección aprendemos una alternativa más simple:
👉 **Dynamic Tables**

---

## 🧠 ¿Qué es una Dynamic Table?

Una Dynamic Table es una tabla que:
- Se define con un SELECT
- Se mantiene actualizada automáticamente
- Tiene una política de frescura (`TARGET_LAG`)

💡 Es como una tabla materializada inteligente mantenida por Snowflake.

---

## ⚙️ Implementación realizada

Creamos la tabla:

`tasty_bytes.raw_pos.daily_sales_hamburg`

### Lógica:
- Filtrar pedidos de Hamburg, Germany
- Convertir timestamp a fecha
- Agrupar por fecha
- Sumar ventas

---

## 🔁 Flujo ejecutado

1. Configuración de contexto
2. Creación de dynamic table
3. Validación inicial
4. Inserción de datos dummy
5. Validación del refresco automático

---

## 📊 Resultados obtenidos

Ejemplo observado:

| date       | total_sales |
|------------|------------|
| 2023-07-01 | 45.8       |
| 2024-03-09 | 24.7       |

✔ Se confirma:
- La tabla se crea correctamente
- Se actualiza automáticamente
- El agregado se recalcula (no duplica filas)

---

## 🧩 Aprendizajes clave

- Las Dynamic Tables simplifican pipelines
- No requieren lógica procedural
- Se enfocan en el estado final de los datos
- Son ideales para agregaciones y capas analíticas

---

## ⚖️ Comparación

| Enfoque | Uso |
|--------|-----|
| Streams + SP + Tasks | Lógica compleja |
| Dynamic Tables | Transformaciones simples |

---

## 🚀 Conclusión

Dynamic Tables permiten construir pipelines más simples, mantenibles y declarativos cuando el caso de uso no requiere control detallado de cambios.

---

## 📁 Estructura

```
module_3/
  automatic_transformations_with_dynamic_tables/
    ├── sql/
    ├── notes.md
    ├── README.md
```
