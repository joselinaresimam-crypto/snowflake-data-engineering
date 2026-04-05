# Notes - Data Transformations with SQL (Nivel PRO)

## 🎯 Contexto de la lección

En esta lección trabajamos con datos de ventas y clima en Snowflake para investigar una anomalía detectada en el negocio:

> 📉 Las ventas en Hamburg, Alemania fueron igual a 0 durante gran parte de febrero 2022.

El objetivo fue aplicar transformaciones con SQL para identificar la causa raíz de este comportamiento.

---

## 🧱 Flujo técnico implementado

### 1. Generación de calendario (Date Spine)

Se utilizó:

- GENERATOR
- SEQ4()
- DATEADD

Esto permitió crear una tabla con todas las fechas de febrero, independientemente de si existen ventas.

👉 Esto es clave porque en tablas transaccionales, los días sin actividad no existen.

---

### 2. LEFT JOIN contra órdenes

Se utilizó LEFT JOIN entre fechas y órdenes:

- Permite mantener todas las fechas
- Detecta días sin ventas (NULL → 0 con ZEROIFNULL)

👉 Resultado:
Se identificó que del **1 al 24 de febrero las ventas fueron 0**

---

### 3. Enriquecimiento con datos de clima

Se creó la vista:

`harmonized.daily_weather_v`

Se integraron:

- Datos de clima (Marketplace)
- Códigos postales
- Información de país/ciudad

👉 Esto representa la capa **HARMONIZED** en arquitectura medallion

---

### 4. Análisis de temperatura

Se calculó la temperatura promedio diaria.

📊 Resultado:
- Valores dentro de rangos normales (30–40°F aprox.)
- No se observa comportamiento anómalo

👉 Conclusión:
❌ La temperatura NO explica la caída de ventas

---

### 5. Análisis de velocidad del viento

Se calculó la velocidad máxima diaria del viento.

📊 Resultados observados:

- 66.5 mph
- 60.2 mph
- 55 mph
- 51.6 mph
- múltiples días > 45 mph

👉 Interpretación:

- >40 mph = condiciones severas
- >60 mph = condiciones tipo tormenta fuerte

👉 Conclusión:
✅ El viento extremo es altamente probable causa de la caída en ventas

---

### 6. Creación de vista final

Se creó:

`harmonized.windspeed_hamburg`

👉 Esto convierte el análisis en un activo reutilizable

---

## 🧠 Insight técnico clave

Existe una correlación temporal directa entre:

- Días con viento extremo
- Días con ventas en cero

---

## ⚠️ Nota importante

Correlación ≠ causalidad absoluta.

Sin embargo:

- Temperatura descartada
- Viento extremo presente
- Coincidencia temporal

👉 Esto da una **causalidad altamente probable**

---

## 🧠 Conclusión técnica

Este ejercicio demuestra:

- Uso de SQL para análisis avanzado
- Importancia de enriquecer datos con fuentes externas
- Cómo transformar datos sin afectar RAW
- Cómo convertir análisis en activos reutilizables
