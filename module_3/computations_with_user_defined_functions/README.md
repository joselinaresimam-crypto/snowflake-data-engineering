# Computations with User-Defined Functions (UDFs)

## Objetivo

Aprender a crear y utilizar **User Defined Functions (UDFs)** en Snowflake para encapsular lógica reutilizable dentro de procesos de transformación de datos, mejorar la mantenibilidad del código y estandarizar cálculos a lo largo de vistas, queries y pipelines.

---

## Contexto de la lección

En transformación de datos, uno de los problemas más comunes es la repetición de lógica. A medida que crecen las tablas, las vistas y los casos de uso, repetir fórmulas manualmente en distintos scripts deja de ser escalable.

Por ejemplo, si en varias consultas necesitas convertir temperatura de Fahrenheit a Celsius o precipitación de pulgadas a milímetros, podrías escribir la fórmula una y otra vez. Sin embargo, eso trae varios problemas:

- aumenta la duplicidad de lógica
- hace más difícil corregir errores
- complica mantener consistencia entre transformaciones
- vuelve más costoso modificar una regla cuando cambia el negocio

Las **UDFs** resuelven esto al permitir definir lógica una sola vez y reutilizarla cuantas veces sea necesario.

---

## ¿Qué es una UDF?

Una **User Defined Function** es una función creada por el usuario que recibe uno o más parámetros y devuelve un solo valor.

En Snowflake, las UDFs son muy útiles para:

- conversiones de unidades
- limpieza o formateo de valores
- cálculos específicos de negocio
- estandarización de reglas de transformación
- reutilización de lógica en múltiples objetos

En esta lección trabajamos con UDFs en **SQL**, aunque Snowflake también permite construirlas con otros lenguajes soportados como Python, JavaScript, Java y Scala, dependiendo del caso.

---

## Qué se realizó en esta lección

### 1. Creación de dos UDFs

Se crearon dos funciones dentro del esquema `analytics`:

- `fahrenheit_to_celsius()`
- `inch_to_millimeter()`

La primera transforma temperaturas de Fahrenheit a Celsius.  
La segunda transforma precipitación de pulgadas a milímetros.

Estas funciones concentran lógica simple, clara y reutilizable, exactamente el tipo de cálculo ideal para una UDF.

---

### 2. Validación previa de las UDFs

Antes de usarlas en vistas, se probaron con valores conocidos para confirmar que los resultados fueran correctos.

Casos validados:

- `32°F → 0°C`
- `212°F → 100°C`
- `1 inch → 25.4 mm`
- `0 inch → 0 mm`

Esta validación fue importante porque en entornos reales nunca conviene integrar lógica no probada directamente a una vista o pipeline.

---

### 3. Uso de UDFs dentro de una vista en `harmonized`

Después de validar las funciones, se usaron para enriquecer la vista `harmonized.weather_hamburg`.

Esta vista permitió agregar al análisis:

- temperatura promedio en Fahrenheit
- temperatura promedio en Celsius
- precipitación promedio en pulgadas
- precipitación promedio en milímetros
- velocidad máxima del viento
- ventas diarias

Esto demuestra cómo una UDF se integra naturalmente dentro de un `SELECT`, igual que una función nativa de SQL.

---

### 4. Expansión a una vista analítica general

Luego se creó la vista:

- `analytics.daily_city_metrics_v`

Su objetivo fue escalar la lógica a todas las ciudades del dataset, dejando disponible una vista más amplia para análisis posteriores.

Con esto, ya no solo teníamos una transformación puntual para Hamburg, sino una base más reutilizable para analítica a nivel ciudad.

---

## Qué aprendimos realmente

Esta lección no solo trata de “crear funciones”. Lo importante es entender el patrón de ingeniería que hay detrás:

1. **Encapsular lógica**
2. **Validar la lógica**
3. **Reutilizarla**
4. **Aplicarla en transformaciones**
5. **Evitar duplicidad**

Ese patrón aparece una y otra vez en data engineering.

---

## Buenas prácticas al crear UDFs

### 1. Crear UDFs solo cuando la lógica realmente se va a reutilizar

No toda fórmula necesita ser una UDF.  
Si una lógica se usa una sola vez y es muy simple, a veces no vale la pena abstraerla.

Una UDF tiene más sentido cuando:

- la misma lógica se usa en varios queries
- se quiere centralizar una regla de negocio
- la fórmula puede cambiar en el tiempo
- se busca estandarizar resultados

---

### 2. Mantenerlas enfocadas en una sola responsabilidad

Una UDF debe hacer una sola cosa y hacerla bien.

Ejemplos correctos:
- convertir temperatura
- convertir moneda
- normalizar un formato
- calcular una bandera específica

Ejemplos menos convenientes:
- una función enorme con múltiples reglas mezcladas
- lógica que intenta limpiar, transformar, clasificar y formatear al mismo tiempo

Mientras más específica sea, más fácil será probarla, entenderla y reutilizarla.

---

### 3. Usar nombres claros y descriptivos

Los nombres deben dejar claro:

- qué hace la función
- qué devuelve
- idealmente, qué unidad o formato transforma

Por ejemplo:

- `fahrenheit_to_celsius`
- `inch_to_millimeter`

Son nombres mucho mejores que:
- `convert_temp`
- `calc_value`
- `udf_1`

Una buena práctica es que el nombre permita entender la función sin abrir su definición.

---

### 4. Validar siempre con casos conocidos

Antes de meter una UDF en una vista o pipeline, conviene probarla con datos cuyo resultado ya conoces.

Esto ayuda a detectar:

- errores en fórmulas
- problemas de tipo de dato
- errores de redondeo
- resultados inesperados con nulos o ceros

En esta lección justamente hicimos eso, y fue una excelente práctica.

---

### 5. Pensar en tipos de datos desde el inicio

Una UDF no solo debe “funcionar”, también debe devolver el tipo correcto.

Hay que cuidar:

- precisión decimal
- tamaño numérico
- tipo de retorno esperado
- compatibilidad con otras transformaciones

Por ejemplo, si una función devuelve `NUMBER(35,4)`, eso ya comunica que el resultado tendrá decimales controlados y suficiente precisión para cálculos posteriores.

---

### 6. Considerar manejo de nulos

En muchos escenarios reales, los datos vienen incompletos.  
Por eso, al diseñar una UDF, conviene pensar:

- ¿qué pasa si el parámetro viene nulo?
- ¿debo devolver nulo?
- ¿debo usar un valor por defecto?
- ¿la función se rompe o se comporta de forma segura?

En esta lección la lógica fue simple, pero en escenarios reales esto importa mucho.

---

### 7. Evitar volverlas demasiado complejas

Aquí está uno de los puntos más importantes.

Las UDFs pueden comenzar siendo muy simples, pero pueden complicarse rápidamente cuando se les empieza a meter:

- múltiples condiciones
- reglas de negocio cambiantes
- limpieza de strings
- lógica temporal
- conversiones especiales
- validaciones internas
- soporte para excepciones

Cuando la función empieza a crecer demasiado, hay que preguntarse si realmente sigue siendo una UDF ideal o si ya conviene otro enfoque, como:

- una vista intermedia
- una tabla derivada
- una stored procedure
- una transformación por etapas

---

### 8. Documentarlas

Aunque sean pequeñas, las UDFs deben quedar documentadas en el proyecto:

- qué hacen
- qué reciben
- qué devuelven
- dónde se usan
- por qué existen

Esto ayuda muchísimo cuando después vuelves al proyecto o cuando otra persona necesita mantenerlo.

---

### 9. Probar performance cuando se usan a gran escala

Una UDF simple no suele ser problema por sí sola.  
Pero cuando se aplica sobre muchas filas dentro de vistas con joins y agregaciones, el costo total puede crecer.

En esta lección lo vimos indirectamente al consultar `analytics.daily_city_metrics_v`, que tardó más de lo esperado aunque solo se pidiera `LIMIT 20`.

La razón es que Snowflake tuvo que resolver:

- joins
- agregaciones
- ejecución de funciones
- agrupaciones globales

Por eso, una buena práctica es medir el costo real cuando la UDF entra en procesos más grandes.

---

## ¿Qué tan complicadas pueden volverse las UDFs?

### Nivel 1: Simples
Son las de esta lección.  
Tienen una fórmula clara, pocos parámetros y un resultado directo.

Ejemplos:
- conversiones
- redondeos
- formateos básicos

Estas son ideales para empezar.

---

### Nivel 2: Intermedias
Aquí ya aparecen:

- múltiples parámetros
- condiciones `CASE`
- validaciones
- lógica de negocio moderada

Ejemplo:
- clasificar un cliente por monto, país y segmento
- calcular una comisión según varios criterios
- normalizar formatos según tipo de dato

Estas siguen siendo manejables, pero ya requieren más pruebas.

---

### Nivel 3: Avanzadas
Se vuelven más complejas cuando:

- usan otros lenguajes como Python o JavaScript
- dependen de librerías o runtime
- procesan estructuras más complejas
- contienen reglas de negocio cambiantes
- necesitan manejo avanzado de excepciones

Aquí ya se vuelve muy importante evaluar si la UDF sigue siendo la mejor opción.

---

### Regla práctica

Si la función ya cuesta mucho trabajo explicar, probar o mantener, probablemente ya está cruzando la línea entre una UDF útil y una lógica que conviene resolver con otro patrón.

---

## Validación final realizada en la lección

Después de crear las UDFs y las vistas, se validó la salida con consultas directas.

Ejemplo de validación:

```sql
SELECT *
FROM harmonized.weather_hamburg
ORDER BY date
LIMIT 20;
```

y también:

```sql
SELECT *
FROM analytics.daily_city_metrics_v
LIMIT 20;
```

La segunda consulta tardó más debido al volumen y a la lógica agregada de la vista, lo cual fue una observación útil para entender que `LIMIT` no siempre significa ejecución inmediata.

---

## Aprendizajes clave

- Una UDF sirve para encapsular lógica reusable
- Ayuda a mantener consistencia en transformaciones
- Conviene validar antes de integrarla a vistas
- Debe ser clara, específica y bien nombrada
- Puede crecer en complejidad rápidamente si no se diseña con cuidado
- Hay que pensar no solo en funcionalidad, sino también en mantenibilidad y performance

---

## Conexión con data engineering real

En un entorno real, este patrón aparece constantemente.

Las UDFs ayudan a:

- estandarizar reglas
- reducir duplicación de lógica
- hacer más mantenibles los pipelines
- construir capas más limpias en `harmonized` y `analytics`

Son pequeñas piezas técnicas, pero muy poderosas cuando se usan bien.

---

## Cierre

Esta lección fue importante porque muestra cómo pasar de fórmulas repetidas a lógica reusable y gobernable. Ese cambio de mentalidad es esencial en data engineering: no solo hacer que algo funcione, sino hacerlo de forma mantenible, escalable y consistente.
