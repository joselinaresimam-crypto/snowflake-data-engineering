# Notes - Data Sharing on Snowflake Marketplace

## 🧠 Concepto central

El data sharing en Snowflake permite compartir datos entre cuentas sin necesidad de copiarlos o moverlos físicamente.

Esto es posible gracias a la arquitectura desacoplada de:
- Storage
- Compute

---

## 🔑 Conceptos fundamentales

### 1. Data Product
Un dataset diseñado específicamente para ser consumido.

Características:
- Limpio
- Documentado
- Consistente
- Listo para uso analítico

---

### 2. Secure Data Sharing

Mecanismo nativo de Snowflake que permite:
- Compartir datos en vivo
- Evitar duplicación
- Mantener consistencia

A diferencia de otros sistemas:
- No requiere exportar/importar
- No requiere pipelines adicionales

---

### 3. Snowflake Marketplace

Plataforma donde:
- Se publican datasets
- Se descubren datos
- Se consumen productos de datos

---

## 🔍 Tipos de listings

### Private Listing
- Controlado
- Requiere account identifiers
- Uso en integraciones específicas

---

### Public Listing
- Visible globalmente
- Requiere perfil de proveedor
- Puede incluir monetización

---

## ⚙️ Componentes del proceso de publicación

1. Dataset:
   - Tablas
   - Views
   - Dynamic Tables

2. Metadata:
   - Nombre
   - Descripción

3. Configuración:
   - Tipo de listing
   - Consumidores

4. Publicación

---

## 🧠 Consideraciones técnicas importantes

### ❗ No duplicación de datos
Los datos permanecen en la cuenta del proveedor.

---

### ⚡ Acceso en tiempo real
Los consumidores acceden a la versión más actualizada.

---

### 🔐 Seguridad
Controlada mediante:
- Roles
- Permisos
- Configuración del share

---

## 📈 Aplicaciones en Data Engineering

- Distribución de datasets analíticos
- Integración entre sistemas
- Compartición entre empresas
- Creación de productos de datos

---

## 🧩 Relación con el Data Engineering Lifecycle

Esta lección pertenece a la fase de:

👉 **Delivery**

Después de:
- Ingestar datos
- Transformarlos

Ahora:
- Se entregan a usuarios finales o sistemas

---

## 🧠 Insight importante

Snowflake cambia el paradigma tradicional:

❌ Antes:
Mover datos entre sistemas

✅ Ahora:
Compartir datos sin moverlos

---

## 📌 Conclusión técnica

El data sharing en Snowflake es una capacidad clave que permite construir arquitecturas modernas, donde los datos se consumen directamente desde su origen, reduciendo complejidad, costos y latencia.
