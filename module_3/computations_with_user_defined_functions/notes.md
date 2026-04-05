# Notes - Computations with User-Defined Functions

## Idea central de la lección

Las transformaciones manuales no escalan bien cuando el número de tablas, vistas y consultas empieza a crecer. Una forma de resolver esto es capturar lógica en componentes reutilizables. En Snowflake, una de las formas más directas de hacerlo es mediante **User Defined Functions (UDFs)**.

Una UDF permite definir una función personalizada una sola vez y luego invocarla tantas veces como sea necesario dentro de queries, vistas o transformaciones.

---

## Qué resuelven las UDFs

Las UDFs son especialmente útiles cuando existe lógica que:

- se repite en varios lugares
- debe mantenerse consistente
- puede cambiar con el tiempo
- conviene centralizar

En vez de repetir fórmulas en cada query, se define una función y se reutiliza. Esto reduce duplicidad y facilita mantenimiento.

---

## Casos de uso típicos

En Snowflake, una UDF suele ser una buena opción para:

- conversiones de unidades
- formateo de datos
- estandarización de textos
- cálculos derivados
- clasificación simple
- reglas pequeñas de negocio

La lección trabajó justo con uno de los casos más clásicos: **conversiones de unidades**.

---

## UDFs creadas en esta práctica

Se crearon dos funciones en SQL:

### 1. `fahrenheit_to_celsius`
Convierte una temperatura en Fahrenheit a Celsius.

Fórmula:

```sql
(temp_f - 32) * (5/9)
```

### 2. `inch_to_millimeter`
Convierte pulgadas a milímetros.

Fórmula:

```sql
inch * 25.4
```

Estas dos funciones fueron un muy buen ejemplo de UDF simple:
- una sola responsabilidad
- fórmula clara
- fácil de validar
- reusable en diferentes consultas

---

## Cómo se define una UDF en Snowflake

La estructura general es:

```sql
CREATE OR REPLACE FUNCTION nombre_funcion(parametro TIPO)
RETURNS TIPO
AS
$$
    logica_sql
$$;
```

Elementos importantes:

- `CREATE OR REPLACE FUNCTION`: crea o reemplaza la función
- nombre de la función
- parámetros de entrada
- tipo de retorno
- bloque delimitado por `$$` que contiene la lógica

---

## Buenas prácticas al crear UDFs

### 1. Diseñarlas para reutilización real
No crear una UDF por cualquier fórmula aislada. La mejor justificación es que la lógica se use en varios puntos o que deba centralizarse.

### 2. Una sola responsabilidad
Entre más concreta sea la función, mejor. Una UDF debe resolver una sola tarea, no varias a la vez.

### 3. Nombres claros
El nombre debe dejar claro qué hace. Esto mejora muchísimo la legibilidad del proyecto.

### 4. Definir bien tipos de entrada y salida
Hay que pensar en precisión, escala y compatibilidad con otros objetos.

### 5. Validar antes de usar
Siempre conviene probar la función con valores cuyo resultado ya conoces.

### 6. Pensar en nulos y casos borde
Aunque la lección fue simple, en escenarios reales una UDF debe considerar qué hacer con entradas nulas, vacías o atípicas.

### 7. Evitar sobrecargarlas
Si la lógica se vuelve demasiado larga, difícil de explicar o difícil de probar, tal vez ya no conviene que viva dentro de una sola UDF.

### 8. Documentar propósito y uso
Aunque sea pequeña, debe quedar claro para qué existe y dónde se consume.

---

## Qué tan complicadas pueden volverse

### UDF simple
- una fórmula
- uno o pocos parámetros
- resultado directo

### UDF intermedia
- varios parámetros
- `CASE WHEN`
- reglas de negocio simples o moderadas
- validaciones

### UDF avanzada
- otros lenguajes como Python o JavaScript
- lógica más extensa
- procesamiento más especializado
- mantenimiento más delicado

La complejidad no solo está en escribirla, sino en:
- probarla
- documentarla
- mantenerla
- entender su impacto cuando corre sobre muchas filas

---

## Cuándo una UDF ya se está volviendo demasiado compleja

Señales de alerta:

- tiene demasiados parámetros
- mezcla varias responsabilidades
- cuesta trabajo explicar qué hace
- requiere demasiados comentarios para entenderse
- se vuelve difícil de probar
- empieza a parecer mini-aplicación dentro de SQL

Cuando pasa eso, puede ser mejor mover la lógica a:
- una vista intermedia
- una transformación por capas
- una stored procedure
- otra estrategia más mantenible

---

## Validación aplicada en esta práctica

Se creó un archivo específico para probar las funciones antes de usarlas en vistas. Esta fue una muy buena práctica.

Ejemplos de prueba:
- `fahrenheit_to_celsius(32)` debe dar `0`
- `fahrenheit_to_celsius(212)` debe dar `100`
- `inch_to_millimeter(1)` debe dar `25.4`

Esto ayudó a asegurar que la lógica estaba correcta antes de integrarla a objetos más grandes.

---

## Uso dentro de vistas

Después de validar las funciones, se integraron en:

### `harmonized.weather_hamburg`
Vista enfocada en Hamburg con clima y ventas.

### `analytics.daily_city_metrics_v`
Vista más general para múltiples ciudades.

Esto mostró un patrón importante:
- primero se crea lógica reusable
- luego se consume en objetos analíticos

Ese orden mejora mantenimiento y claridad.

---

## Aprendizaje técnico importante sobre performance

Aunque una UDF pueda ser simple, su uso dentro de una vista más grande puede contribuir al costo total de ejecución si además hay:

- joins
- agregaciones
- group by
- volumen alto de datos

La consulta a `analytics.daily_city_metrics_v` tardó más de lo esperado incluso con `LIMIT 20`, lo cual dejó una lección importante:

> `LIMIT` no garantiza respuesta inmediata si antes Snowflake necesita resolver una transformación pesada.

Esto no significa que la UDF esté mal, sino que hay que entender el contexto completo donde se ejecuta.

---

## Relación con Snowflake y arquitectura de datos

Las UDFs encajan muy bien en arquitecturas por capas porque permiten estandarizar cálculos dentro de las capas transformadas, por ejemplo:

- `raw`: datos crudos
- `harmonized`: datos limpiados y enriquecidos
- `analytics`: datos listos para consumo analítico

En esta práctica, las funciones ayudaron a enriquecer datos en vistas que ya se ubican en capas más avanzadas de transformación.

---

## Conclusión

Las UDFs son una herramienta muy poderosa cuando se usan con criterio. No son para meter toda la lógica posible, sino para encapsular cálculos específicos, claros y repetibles.

Bien diseñadas, ayudan a construir soluciones:
- más limpias
- más mantenibles
- más consistentes
- más cercanas a prácticas reales de data engineering
