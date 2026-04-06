# Data Sharing on Snowflake Marketplace

## 🎯 Objetivo de la lección
Comprender cómo Snowflake permite compartir datasets como productos de datos mediante el Marketplace, habilitando la entrega de valor a usuarios internos y externos sin mover ni duplicar datos.

---

## 🧠 Contexto dentro del Data Engineering Lifecycle

En un pipeline moderno de data engineering, existen tres grandes fases:

1. **Ingesta (Ingestion)** → traer datos desde fuentes
2. **Transformación (Transformation)** → limpiar, enriquecer y modelar datos
3. **Entrega (Delivery)** → poner los datos a disposición de usuarios o sistemas

👉 Esta lección se enfoca en la tercera fase: **Delivery**

Aquí ya no trabajamos con datos crudos, sino con:
- Datos listos
- Datos confiables
- Datos diseñados para consumo

---

## 📦 ¿Qué es Snowflake Marketplace?

Snowflake Marketplace es una plataforma dentro del Data Cloud que permite:

- Compartir datasets con otros usuarios de Snowflake
- Consumir datasets externos
- Publicar datos como productos

Funciona como un **ecosistema de intercambio de datos**, donde los datasets pueden ser:
- Públicos
- Privados
- Gratuitos o monetizados

---

## 🔑 Concepto clave: Data as a Product

Esta lección introduce un cambio importante:

❌ Antes:
> “Tengo una tabla”

✅ Ahora:
> “Tengo un producto de datos listo para consumo”

Un **Data Product** implica:
- Estructura clara
- Definiciones consistentes
- Calidad garantizada
- Facilidad de uso

Ejemplos:
- KPIs de negocio
- Dataset de ventas limpio
- Datos enriquecidos con fuentes externas

---

## 🔄 Tipos de Data Sharing en Snowflake

### 🔐 1. Compartición interna
- Dentro de la misma cuenta
- Uso básico entre equipos

---

### 🔒 2. Private Listing
- Compartición con cuentas específicas
- Uso común en:
  - Empresas que colaboran
  - Integraciones B2B

Ejemplo:
Una empresa comparte datos con un partner estratégico.

---

### 🌎 3. Public Listing
- Visible en el Marketplace
- Requiere configuración de proveedor
- Puede ser:
  - Gratis
  - De pago

Ejemplo:
Datasets de clima, financieros, geográficos

---

## ⚙️ Flujo de publicación (según la lección)

1. Ir a **Data Products → Provider Studio**
2. Crear un nuevo listing
3. Definir:
   - Nombre del dataset
   - Tipo de listing (public/private)
   - Objetos a compartir (tablas, dynamic tables)
4. Agregar descripción
5. Definir consumidores (si es privado)
6. Publicar

---

## 🧠 ¿Qué ocurre internamente?

Uno de los puntos más importantes:

👉 Snowflake NO copia los datos

En su lugar usa:

### 🔐 Secure Data Sharing

Esto permite:
- Acceso en tiempo real
- Sin duplicación
- Sin pipelines adicionales

Beneficios:
- Menor costo
- Mayor eficiencia
- Consistencia garantizada

---

## 📈 Importancia en el mundo real

El data sharing es clave en:

- Data collaboration
- Data monetization
- Ecosistemas de datos

Permite:
- Compartir información entre empresas
- Integrar datos sin ETLs complejos
- Escalar el valor de los datos

---

## 🧠 Aprendizajes clave

- Snowflake Marketplace permite distribuir datos como productos
- El sharing es seguro, eficiente y en tiempo real
- No es necesario duplicar datos
- El enfoque cambia de tablas a productos de datos

---

## 📌 Conclusión

El Marketplace de Snowflake es una herramienta fundamental para la fase de delivery en data engineering. Permite compartir datos de forma segura, eficiente y escalable, habilitando nuevos modelos de colaboración y monetización dentro del Data Cloud.
