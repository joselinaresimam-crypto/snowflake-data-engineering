# Ingesting Data from Other Data Systems using Connectors

## 🎯 Objetivo
Entender cómo Snowflake permite ingerir datos desde otros sistemas y aplicaciones externas mediante el uso de conectores nativos (connectors), sin necesidad de construir integraciones manuales complejas.

---

## 🧩 Contexto

En escenarios reales de data engineering, los datos no siempre están disponibles como archivos (CSV, JSON, Parquet) o en almacenamiento en la nube.

Muchas veces los datos viven en:
- Sistemas externos (bases de datos)
- Aplicaciones SaaS (Salesforce, Google Ads, etc.)
- Plataformas propietarias
- APIs de terceros

En estos casos, no siempre se tiene acceso directo o no es eficiente construir pipelines desde cero.

---

## 🔌 ¿Qué son los Connectors?

Los **connectors** en Snowflake son integraciones nativas que permiten conectar Snowflake con otros sistemas de datos o aplicaciones externas.

Características principales:
- Evitan construir integraciones manuales desde cero
- No requieren consumir APIs directamente
- Permiten automatizar la actualización de datos
- Reducen la complejidad del pipeline de ingestión

---

## 🧠 Snowflake Native Connectors

Muchos connectors están disponibles como:

- **Snowflake Native Applications**
- Integraciones dentro del **Snowflake Marketplace**

Esto significa que puedes:
1. Buscar un conector
2. Instalarlo en tu cuenta
3. Configurarlo según tu caso de uso

---

## 🔄 Actualización de datos

Una de las ventajas clave de los connectors es que:

👉 Los datos pueden actualizarse automáticamente con una frecuencia definida.

Esto permite:
- Mantener datos sincronizados
- Evitar procesos manuales
- Automatizar pipelines de ingestión

---

## ⚖️ Comparación con otros métodos de ingestión

| Método | Cuándo usarlo |
|------|-------------|
| Archivos + COPY INTO | Cuando tienes acceso directo a los datos |
| Stages | Para gestionar archivos dentro de Snowflake |
| Connectors | Cuando los datos están en sistemas externos |

---

## 🏢 Ejemplo en el mundo real

Una empresa puede tener datos en:

- Salesforce (clientes)
- Google Ads (marketing)
- ServiceNow (soporte)
- Base de datos interna (operaciones)

Sin connectors:
- Se requieren APIs
- Manejo de autenticación
- Desarrollo de pipelines custom

Con connectors:
- Integración simplificada
- Menor esfuerzo de ingeniería
- Actualización automatizada

---

## 🚧 Problemas que resuelven

Los connectors ayudan a resolver:

- Falta de acceso directo a los datos
- Complejidad en APIs externas
- Mantenimiento de pipelines
- Sincronización de datos
- Gestión de credenciales

---

## 📍 Dónde encontrarlos

Puedes explorar connectors en:

- Sección **Add Data** en Snowflake
- **Snowflake Marketplace**
- Páginas de listing de integraciones

---

## 🧠 Aprendizajes clave

- La ingestión de datos no se limita a archivos
- Snowflake puede integrarse con otros sistemas
- Los connectors simplifican la arquitectura
- Son clave en entornos empresariales reales
- Reducen el esfuerzo de data engineering

---

## 🔗 Conexión con Data Engineering real

En el mundo real:
- Los datos están distribuidos en múltiples sistemas
- No siempre tienes control del origen
- Elegir la estrategia de ingestión correcta es crítico

Los connectors representan una solución moderna para integrar datos de forma eficiente y escalable.

---

## ✅ Conclusión

Snowflake no solo permite cargar datos desde archivos, sino también integrarse con otros sistemas mediante conectores nativos.

Esto amplía significativamente las capacidades de ingestión y permite construir arquitecturas de datos más robustas y eficientes.
