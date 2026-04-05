# 🚀 Data Transformations with SQL in Snowflake

## 🎯 Objetivo

Identificar y explicar una anomalía en ventas utilizando transformaciones SQL en Snowflake, integrando datos internos y externos.

---

## 🧠 Contexto del problema

Se detectó que:

> 📉 Las ventas en Hamburg, Alemania fueron 0 durante la mayor parte de febrero 2022.

Este comportamiento es atípico y requiere investigación.

---

## ⚙️ Qué se hizo paso a paso

### 1. Generación de fechas completas
Se generó un calendario completo de febrero 2022 usando GENERATOR.

👉 Esto permite detectar días sin actividad.

---

### 2. Identificación de ventas en cero

Se realizó LEFT JOIN contra órdenes.

📊 Resultado:

- Del 1 al 24 de febrero → ventas = 0

---

### 3. Integración de datos de clima

Se creó una vista harmonized que combina:

- Datos de clima
- Ubicación geográfica
- Información de negocio

---

### 4. Análisis de temperatura

📊 Resultado:

- Temperatura estable
- Sin anomalías relevantes

👉 Se descarta como causa

---

### 5. Análisis de velocidad del viento

📊 Resultados clave:

- Hasta 66.5 mph
- Múltiples días > 50 mph

👉 Interpretación:

- Condiciones extremas
- Posible impacto en movilidad y consumo

---

## 🎯 Resultado final (Insight)

> 💡 La caída en ventas coincide con múltiples días de viento extremo, lo que probablemente afectó la actividad comercial en Hamburg.

---

## 🧱 Qué construimos

- Queries analíticos
- Vista harmonized
- Vista de monitoreo (windspeed_hamburg)

---

## 🧠 Aprendizajes clave

- Uso de LEFT JOIN para detectar anomalías
- Importancia de generar date spine
- Integración de fuentes externas
- Separación de capas (RAW vs HARMONIZED)
- Transformaciones sin alterar datos originales

---

## 🏗️ Aplicaciones

Este caso replica escenarios reales donde:

- Se detectan anomalías en métricas
- Se investigan causas con datos externos
- Se construyen datasets reutilizables
- Se habilita monitoreo futuro

---

## 📁 Estructura del proyecto

sql/
- 01_set_context.sql
- 02_identify_zero_sales_dates.sql
- 03_create_daily_weather_view.sql
- 04_analyze_temperature.sql
- 05_analyze_wind_speed.sql
- 06_create_windspeed_monitoring_view.sql

source/
- hamburg_sales_original.sql

---

## 🚀 Conclusión

Este ejercicio demuestra cómo SQL en Snowflake puede utilizarse no solo para consultas, sino para:

- análisis avanzado
- toma de decisiones
- generación de insights de negocio

