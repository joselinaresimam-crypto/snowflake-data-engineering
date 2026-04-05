# Notes - Data transformations in Visual Studio Code (Optional)

## 1. Idea central de la lección

La lección muestra cómo usar la extensión de Snowflake en Visual Studio Code para ejecutar SQL directamente desde el editor.  
No cambia la lógica de transformación ya aprendida, pero sí cambia el **entorno operativo** desde el que se trabaja.

Eso la vuelve relevante porque en este proyecto el objetivo no es solo aprender Snowflake, sino aprender a usarlo **como se trabajaría en un contexto real de ingeniería de datos**.

---

## 2. Qué se está reforzando realmente

Esta lección no trata de “aprender una consulta nueva”.  
Lo que refuerza es esto:

- desarrollo desde archivos
- ejecución controlada desde el editor
- separación entre desarrollo y UI
- trazabilidad del trabajo técnico
- disciplina para establecer contexto antes de ejecutar

En términos simples:  
**se formaliza el entorno de trabajo**.

---

## 3. VS Code vs Snowsight

Snowsight es muy útil para:

- explorar objetos
- revisar resultados rápidamente
- navegar por el entorno
- hacer validaciones visuales
- administrar ciertos elementos desde la UI

Pero VS Code es mejor para:

- desarrollar scripts de forma organizada
- trabajar con Git
- mantener estructura de carpetas
- documentar junto con el código
- combinar SQL, Python y markdown en un mismo entorno
- construir una práctica más reproducible

### Resumen práctico

- **Snowsight**: más orientado a exploración y operación visual
- **VS Code**: más orientado a desarrollo, versionamiento y disciplina técnica

La mejor práctica no es eliminar uno u otro, sino entender que el **punto central de desarrollo** debe ser VS Code cuando el objetivo es construir un flujo profesional.

---

## 4. La buena práctica más importante: definir contexto

Cuando se ejecuta una consulta desde VS Code, no conviene asumir que la sesión ya “trae” el contexto correcto.

Por eso una práctica fundamental es iniciar cada script con sentencias como estas:

```sql
-- Usamos un rol con permisos amplios para seguir el laboratorio.
USE ROLE accountadmin;

-- Definimos el warehouse que se utilizará para ejecutar consultas.
USE WAREHOUSE compute_wh;

-- Seleccionamos la base de datos donde vive el dataset Tasty Bytes.
USE DATABASE tasty_bytes;
```

Y cuando sea necesario, también:

```sql
USE SCHEMA harmonized;
```

---

## 5. ¿Qué resuelve definir el contexto?

### a) Evita errores de permisos
Si no defines el rol correcto, una consulta puede fallar por privilegios.

### b) Evita usar cómputo incorrecto
Si no defines el warehouse, podrías consumir recursos distintos a los esperados o incluso no tener uno activo.

### c) Evita crear objetos en lugares equivocados
Si la base o el schema activos no son correctos, puedes terminar creando tablas, vistas o transforms en un sitio distinto al deseado.

### d) Hace el script reproducible
Otra persona puede abrir el archivo, ejecutarlo y obtener el mismo comportamiento esperado sin depender del estado previo de su sesión.

### e) Reduce ambigüedad
El script se vuelve explícito: deja claro dónde corre y contra qué objetos trabaja.

---

## 6. Qué pasa internamente en Snowflake

Estas sentencias no transforman datos por sí mismas, pero sí configuran la sesión activa.

### `USE ROLE`
Define el marco de permisos bajo el que correrán las consultas.  
Esto impacta qué objetos puedes ver, modificar o crear.

### `USE WAREHOUSE`
Define el recurso de cómputo que ejecutará las consultas.  
En Snowflake, el warehouse es quien realiza el trabajo de procesamiento.

### `USE DATABASE`
Define la base de datos activa para resolver nombres de objetos.

### `USE SCHEMA`
Define el esquema activo dentro de la base de datos.

En conjunto, estas sentencias determinan el “contexto operativo” del script.

---

## 7. Patrón profesional recomendado

En este proyecto conviene usar un patrón simple y consistente:

### Bloque 1: encabezado
Describe el propósito del archivo.

### Bloque 2: contexto
Define rol, warehouse, database y schema.

### Bloque 3: validación rápida
Por ejemplo:

```sql
SELECT
    CURRENT_ROLE(),
    CURRENT_WAREHOUSE(),
    CURRENT_DATABASE(),
    CURRENT_SCHEMA();
```

### Bloque 4: transformación o consulta principal
Aquí vive el trabajo real del script.

### Bloque 5: validación de salida
Consultas de verificación o revisión de resultados.

Este orden hace que los archivos sean más legibles y mantenibles.

---

## 8. Por qué esta práctica escala bien

Cuando el proyecto crece, ya no basta con “recordar” cuál base estabas usando o qué warehouse tenías activo.

A mayor complejidad:

- más ambientes
- más objetos
- más scripts
- más riesgo de errores
- más necesidad de trazabilidad

Por eso estas pequeñas prácticas se vuelven muy valiosas.  
Lo que parece un detalle en una lección sencilla, luego se convierte en un hábito crítico en proyectos grandes.

---

## 9. Conexión con Git y portafolio

Trabajar desde VS Code fortalece varias cosas al mismo tiempo:

- el código se guarda localmente
- los cambios se versionan
- la documentación vive cerca del código
- el proyecto queda publicable en GitHub
- el aprendizaje se convierte en evidencia profesional

Eso es especialmente importante en este repositorio, porque no solo queremos “hacer el curso”, sino construir algo que funcione como:

- guía práctica
- portafolio técnico
- base para proyectos reales

---

## 10. Qué nos deja esta lección

Aunque es opcional, deja una definición importante para el resto del proyecto:

> el desarrollo principal se hace desde VS Code y cada script debe declarar su contexto de ejecución al inicio.

Ese acuerdo mejora:

- orden
- claridad
- control
- reproducibilidad
- mantenimiento

---

## 11. Conclusión técnica

La lección es sencilla, pero el mensaje técnico de fondo es fuerte:

- desarrollar en archivos es mejor que depender de la UI
- definir el contexto al inicio del script es una práctica esencial
- VS Code + Snowflake permite una forma de trabajo más cercana a entornos reales
- documentar esta práctica tiene valor porque fija el estándar del proyecto

En resumen:  
**esta lección no nos enseñó más SQL; nos ayudó a consolidar una mejor forma de trabajar con Snowflake.**
