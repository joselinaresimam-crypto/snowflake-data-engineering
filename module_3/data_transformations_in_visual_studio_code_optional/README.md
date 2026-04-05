# Data transformations in Visual Studio Code (Optional)

## Objetivo

Documentar cómo trabajar con Snowflake desde Visual Studio Code usando la extensión oficial, incluyendo la conexión al entorno, la ejecución de queries y una buena práctica clave: **definir explícitamente el contexto de trabajo antes de ejecutar transformaciones**.

---

## Contexto de la lección

En el curso, esta lección es opcional y está pensada para usuarios que trabajan desde Visual Studio Code.  
En nuestro caso, esta lección sí tiene valor documental, aunque no introduzca una transformación nueva, porque:

- ya adoptamos **VS Code como entorno principal de desarrollo**
- ejecutamos el trabajo técnico desde archivos versionados
- usamos Snowflake desde un flujo más cercano al de un entorno real de Data Engineering
- dejamos Snowsight como apoyo visual o administrativo, no como punto central de desarrollo

Por eso, más que aprender una funcionalidad nueva, esta lección sirve para **formalizar y documentar el estándar de trabajo del proyecto**.

---

## ¿Qué aporta esta lección?

Aunque el contenido no agrega una técnica nueva de transformación, sí refuerza algo muy importante:

> en proyectos reales de ingeniería de datos, no basta con saber escribir SQL; también hay que saber **dónde**, **cómo** y **bajo qué contexto** se ejecuta ese SQL.

Trabajar desde VS Code permite:

- mantener el código en archivos reutilizables
- versionar cambios con Git
- documentar cada paso del desarrollo
- ejecutar transformaciones de forma reproducible
- centralizar SQL, Python, documentación y estructura del proyecto en un mismo entorno

---

## ¿Por qué es importante definir el contexto antes de ejecutar SQL?

Cuando trabajamos desde VS Code, una buena práctica fundamental es **establecer explícitamente el contexto de ejecución**.  
Esto significa indicar antes de nuestras consultas:

- qué **rol** se utilizará
- qué **warehouse** ejecutará el cómputo
- qué **base de datos** será el punto de trabajo
- y, cuando aplique, qué **schema** se utilizará

Esto evita ejecutar código en el lugar equivocado, usar recursos incorrectos o generar objetos en esquemas distintos a los esperados.

### Ejemplo base de contexto

```sql
-- Usamos un rol con permisos amplios para seguir el laboratorio.
USE ROLE accountadmin;

-- Definimos el warehouse que se utilizará para ejecutar consultas.
USE WAREHOUSE compute_wh;

-- Seleccionamos la base de datos donde vive el dataset Tasty Bytes.
USE DATABASE tasty_bytes;
```

### ¿Por qué esta práctica es tan importante?

Porque en Snowflake el contexto importa mucho.  
Una misma consulta puede comportarse de manera distinta o incluso fallar si:

- el rol no tiene permisos suficientes
- el warehouse no está seleccionado
- la base de datos activa no es la correcta
- el schema actual no corresponde al objeto esperado

Definir el contexto al inicio del archivo hace que el script sea:

- más claro
- más portable
- más fácil de revisar
- más seguro de ejecutar en distintas sesiones
- menos dependiente del estado previo del editor o de la conexión activa

---

## Paso a paso para conectar VS Code con Snowflake

## 1. Instalar la extensión oficial de Snowflake

Desde VS Code:

1. Abrir la vista de extensiones
2. Buscar **Snowflake**
3. Instalar la extensión oficial

Esta extensión permite trabajar con Snowflake directamente desde VS Code y normalmente ofrece:

- conexión al entorno
- exploración de objetos
- historial de queries
- ejecución de bloques SQL
- ejecución de archivos completos

---

## 2. Obtener el identificador o URL de la cuenta

Para conectarte, necesitas identificar correctamente tu cuenta de Snowflake.

Una forma común es hacerlo desde Snowsight:

1. Abrir Snowsight
2. Ubicar la información de la cuenta
3. Copiar el **account URL** o identificador de cuenta

Ese dato se usa después dentro de la extensión para iniciar sesión.

---

## 3. Iniciar sesión desde VS Code

Una vez instalada la extensión:

1. Haz clic en el ícono de Snowflake dentro de VS Code
2. Selecciona la opción para conectarte
3. Pega el account URL o account identifier
4. Ingresa tus credenciales
5. Completa el acceso

Una vez autenticado, VS Code queda conectado a tu entorno de Snowflake y podrás ejecutar código directamente desde el editor.

---

## 4. Abrir o crear un archivo SQL

La forma correcta de trabajar en este proyecto es ejecutar el código desde archivos `.sql`, no escribir consultas aisladas sin estructura.

Por ejemplo:

```sql
-- =========================================================
-- Lección: Data transformations in Visual Studio Code
-- Objetivo: ejecutar consultas desde VS Code contra Snowflake
-- =========================================================

-- 1) Definir contexto
USE ROLE accountadmin;
USE WAREHOUSE compute_wh;
USE DATABASE tasty_bytes;

-- 2) Ejecutar consulta de prueba
SELECT CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE();
```

Este patrón permite validar rápidamente que la sesión está usando el contexto esperado.

---

## 5. Ejecutar bloques o archivos completos

Desde la extensión puedes trabajar de dos formas:

### Ejecutar un bloque específico
Útil para pruebas controladas, validaciones o desarrollo incremental.

### Ejecutar el archivo completo
Útil cuando el script ya está bien estructurado y quieres correrlo de principio a fin.

Esto es especialmente valioso en proyectos reales, porque te permite desarrollar por etapas:

- primero contexto
- luego validaciones
- después DDL o transformaciones
- finalmente pruebas de salida

---

## 6. Validar resultados en VS Code

Una vez ejecutadas las consultas, puedes revisar:

- el panel inferior de resultados
- el historial de queries
- el explorador de objetos
- los mensajes de error o confirmación

Esto acerca la experiencia a un entorno de desarrollo integrado, sin depender completamente de Snowsight.

---

## Patrón recomendado para scripts SQL en este proyecto

Para mantener orden y reproducibilidad, una estructura recomendada para un archivo SQL es:

```sql
-- =========================================================
-- Título del archivo
-- Propósito general del script
-- =========================================================

-- 1) Definir contexto
USE ROLE accountadmin;
USE WAREHOUSE compute_wh;
USE DATABASE tasty_bytes;
USE SCHEMA harmonized;

-- 2) Validaciones opcionales del entorno
SELECT CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

-- 3) Transformación principal
-- CREATE / REPLACE VIEW ...
-- CREATE / REPLACE TABLE ...
-- SELECT ...
```

Este patrón ayuda a que cualquier persona que abra el archivo entienda de inmediato:

- dónde corre
- con qué permisos
- sobre qué base trabaja
- cuál es el objetivo del script

---

## Buenas prácticas adoptadas

### 1. Definir siempre el contexto al inicio
Evita errores por sesiones previas o contextos heredados.

### 2. Un archivo = un propósito
Cada archivo debe tener una responsabilidad clara.

### 3. Nombrar scripts con prefijos
Por ejemplo:

- `01_...`
- `02_...`
- `03_...`

Esto ayuda a ordenar la ejecución lógica.

### 4. Comentar el código
No se trata de comentar todo por comentar, sino de explicar:

- por qué se usa cierto rol
- por qué se selecciona cierto warehouse
- qué hace la transformación
- qué se espera validar

### 5. Ejecutar desde VS Code, no depender de la UI
Snowsight es útil, pero el desarrollo principal debe vivir en archivos versionados.

### 6. Validar contexto antes de transformar
Una pequeña validación al inicio puede evitar errores costosos.

---

## Relación con Data Engineering real

Esta lección se conecta directamente con prácticas reales de ingeniería de datos.

En entornos profesionales:

- el código vive en repositorios
- los cambios se revisan en archivos
- los pipelines se construyen de forma reproducible
- el contexto de ejecución debe ser explícito
- la trazabilidad del desarrollo importa tanto como el resultado

Por eso, aunque esta lección sea opcional, sí vale la pena documentarla: refleja una forma de trabajo más madura y escalable.

---

## Resultado de la lección

Con esta práctica queda establecido que:

- VS Code es el entorno principal de desarrollo del proyecto
- Snowflake puede ejecutarse directamente desde el editor
- las consultas deben iniciar definiendo contexto
- el trabajo queda mejor preparado para versionamiento, mantenimiento y escalabilidad

---

## Aprendizajes clave

- Ejecutar SQL desde VS Code no solo es cómodo; es una práctica profesional
- Definir `USE ROLE`, `USE WAREHOUSE` y `USE DATABASE` al inicio del script reduce errores
- Un flujo reproducible depende de archivos claros, comentados y versionados
- La herramienta no reemplaza la comprensión del contexto; la refuerza

---

## Conclusión

Esta lección no buscó enseñar una transformación nueva, sino reforzar una forma correcta de trabajar.

El aprendizaje importante no es únicamente “cómo conectar VS Code con Snowflake”, sino entender que en Data Engineering moderno el desarrollo debe ser:

- ordenado
- reproducible
- explícito
- portable
- versionado

Y justo por eso documentar esta práctica sí aporta valor al portafolio.
