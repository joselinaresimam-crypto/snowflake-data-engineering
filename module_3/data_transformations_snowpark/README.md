# Data transformations with Snowpark

## Objetivo
Aprender a realizar transformaciones de datos en Snowflake usando **Snowpark for Python**, replicando en VS Code una transformación que originalmente el curso ejecuta dentro de un **Snowflake Notebook**. El enfoque de esta lección es entender cómo trabajar con **DataFrames** sobre datos almacenados en Snowflake sin depender de SQL como único lenguaje de transformación.

---

## Contexto de la lección
En la lección anterior realizamos transformaciones con SQL. En esta ocasión hicimos la misma lógica, pero usando **Snowpark for Python**. Esto es importante porque en proyectos reales no siempre queremos que toda la lógica viva únicamente en SQL; muchas veces conviene trabajar con Python por legibilidad, reutilización, integración con pipelines y familiaridad con ecosistemas como Spark o pandas.

El curso explica que Snowpark permite ejecutar transformaciones con **Python, Java o Scala** mediante una API de DataFrames y que el procesamiento se empuja al motor de cómputo de Snowflake, evitando que la memoria local de la computadora se convierta en el límite principal del trabajo analítico o de ingeniería de datos. La lección usa un **Snowflake Notebook**, pero en este proyecto se adaptó el ejercicio para ejecutarlo desde **VS Code**, siguiendo un flujo más cercano al trabajo real de data engineering. Esto sigue directamente el espíritu de la lección original, que presenta Snowpark como una alternativa flexible y potente para transformar datos dentro de Snowflake.

---

## Marco conceptual: Spark, PySpark y Snowpark

### ¿Qué es Apache Spark?
**Apache Spark** es un motor de procesamiento distribuido diseñado para trabajar con grandes volúmenes de datos. Su propuesta principal es permitir transformaciones, agregaciones y análisis a gran escala de forma eficiente. Spark se volvió muy popular porque permite dividir el trabajo entre múltiples nodos de cómputo y porque ofrece una API bastante expresiva para procesamiento batch, streaming, machine learning y más.

En términos simples, Spark resuelve este problema:

> cuando los datos ya son demasiado grandes o el procesamiento demasiado pesado para trabajarse cómodamente en una sola máquina, se necesita un motor distribuido que reparta el trabajo.

### ¿Qué es PySpark?
**PySpark** es la interfaz de Spark para Python. Es decir, permite usar Spark desde código Python. En lugar de depender solo de SQL o de APIs en Scala/Java, PySpark deja trabajar con DataFrames, filtros, agregaciones y joins desde Python.

Esto hizo que muchos equipos de datos adoptaran PySpark porque:
- Python es mucho más amigable para analistas, científicos de datos e ingenieros.
- La sintaxis de DataFrames es clara y modular.
- Facilita integración con notebooks, scripts, pipelines y librerías del ecosistema Python.

### ¿Qué es Snowpark?
**Snowpark** es el framework de Snowflake para desarrollar transformaciones usando **Python, Java o Scala** con una experiencia parecida a trabajar con DataFrames tipo Spark, pero ejecutando el trabajo dentro de Snowflake.

La idea clave es esta:

- Con PySpark, el procesamiento vive en Spark.
- Con Snowpark, el procesamiento vive en Snowflake.

Snowpark no busca ser “Spark dentro de Snowflake”, sino ofrecer un modelo de desarrollo similar para aprovechar el cómputo y almacenamiento nativos de Snowflake.

### ¿Por qué Snowpark es importante?
Porque permite:
- escribir transformaciones complejas en Python sin sacar los datos de Snowflake;
- mantener el procesamiento cerca de los datos;
- aprovechar los **virtual warehouses** de Snowflake;
- reducir dependencia de memoria local;
- construir lógica más reutilizable y mantenible que grandes bloques de SQL;
- integrar mejor flujos de ingeniería, analítica avanzada y machine learning.

---

## Diferencia entre SQL, PySpark y Snowpark

| Enfoque | Dónde vive el procesamiento | Lenguaje principal | Cuándo destaca |
|---|---|---|---|
| SQL en Snowflake | Snowflake | SQL | Transformaciones declarativas, simples o medianas |
| PySpark | Cluster Spark | Python | Grandes volúmenes fuera de Snowflake o ecosistema Spark |
| Snowpark | Snowflake | Python / Java / Scala | Transformaciones programáticas dentro de Snowflake |

La lección demuestra que una transformación que antes hicimos en SQL también puede construirse con DataFrames de Snowpark. Esto no significa que SQL deje de ser útil; significa que ahora tenemos **otra interfaz de trabajo**, más cercana a programación y más flexible para ciertos escenarios.

---

## Qué hicimos en esta lección
Tomamos como referencia el notebook del curso (`hamburg_sales_snowpark.ipynb`) y lo adaptamos a un script de Python ejecutado desde VS Code.

La transformación consistió en:
1. abrir una sesión Snowpark con la conexión local configurada en Snowflake CLI;
2. cargar la vista `tasty_bytes.harmonized.daily_weather_v` como DataFrame;
3. filtrar registros para **Hamburg, Germany**, durante **febrero de 2022**;
4. agrupar por país, ciudad y fecha;
5. calcular la velocidad máxima del viento con `max_wind_speed_100m_mph`;
6. ordenar los resultados por fecha descendente;
7. mostrar el resultado en terminal;
8. guardar el resultado en una vista llamada `tasty_bytes.harmonized.windspeed_hamburg_snowpark`.

---

## Estructura del trabajo en el proyecto
La lección quedó organizada en esta ruta:

```text
snowflake-data-engineering/
└── module_3/
    └── data_transformations_snowpark/
        ├── notebooks/
        │   └── snowpark_transformations.py
        ├── sql/
        ├── notes.md
        └── README.md
```

### ¿Por qué usamos `.py` y no `.ipynb`?
Aunque el curso usa un notebook, en este proyecto decidimos trabajar con un script `.py` por estas razones:
- es más fácil de versionar en Git;
- es más limpio para portafolio;
- se parece más a un flujo real de ingeniería;
- evita depender de la interfaz web de Snowflake;
- mantiene la práctica alineada con el estándar del proyecto: trabajar principalmente desde **VS Code**.

El notebook original del curso se usó como referencia, pero el entregable principal quedó como script versionable.

---

## Paso a paso técnico de lo que hicimos

### 1. Confirmamos la conexión correcta
Al intentar usar `Session.builder.getOrCreate()` apareció un error porque la conexión por defecto `default` no estaba configurada. Sin embargo, la cuenta sí tenía una conexión válida guardada con otro nombre.

Se validó con:

```bash
snow connection test -c modern_data_engineering_snowflake
```

Resultado: la conexión respondió correctamente con estado **OK**.

### 2. Instalamos Snowpark for Python
En el entorno local validamos la instalación de:

```bash
pip install snowflake-snowpark-python
```

La librería ya estaba instalada correctamente. El problema nunca fue la instalación, sino el nombre de la conexión a utilizar.

### 3. Adaptamos el notebook del curso a VS Code
El notebook del curso usa:

```python
from snowflake.snowpark.context import get_active_session
session = get_active_session()
```

Eso funciona dentro de Snowflake Notebooks, donde ya existe una sesión activa. En VS Code no existe ese contexto automático, por lo que tuvimos que crear la sesión de forma explícita usando la conexión de Snowflake CLI.

### 4. Creamos el script `snowpark_transformations.py`
El script quedó con esta lógica:

```python
from snowflake.snowpark import Session
from snowflake.snowpark.functions import col, max as sp_max, year, month

connection_parameters = {
    "connection_name": "modern_data_engineering_snowflake"
}

session = Session.builder.configs(connection_parameters).create()

print("Conexión exitosa a Snowflake")

daily_weather = session.table("tasty_bytes.harmonized.daily_weather_v")

filtered_weather = daily_weather.filter(
    (col("country_desc") == "Germany") &
    (col("city_name") == "Hamburg") &
    (year(col("date_valid_std")) == 2022) &
    (month(col("date_valid_std")) == 2)
)

aggregated_weather = filtered_weather.group_by(
    "country_desc", "city_name", "date_valid_std"
).agg(
    sp_max("max_wind_speed_100m_mph").alias("max_wind_speed_100m_mph")
)

sorted_weather = aggregated_weather.sort(col("date_valid_std").desc())

sorted_weather.show(30)

sorted_weather.create_or_replace_view(
    "tasty_bytes.harmonized.windspeed_hamburg_snowpark"
)

print("Vista creada correctamente: tasty_bytes.harmonized.windspeed_hamburg_snowpark")
```

### 5. Ejecutamos desde VS Code
Desde la raíz del proyecto corrimos:

```bash
python module_3/data_transformations_snowpark/notebooks/snowpark_transformations.py
```

### 6. Validamos resultados
La ejecución devolvió correctamente los registros diarios para Hamburg en febrero de 2022 y creó la vista final sin errores.

---

## Explicación detallada del script

### `Session`
`Session` representa la conexión activa a Snowflake desde Snowpark. Es el punto de entrada para leer tablas, crear DataFrames y ejecutar acciones.

### `connection_name`
En vez de usar una conexión por defecto inexistente, se declaró explícitamente la conexión:

```python
connection_parameters = {
    "connection_name": "modern_data_engineering_snowflake"
}
```

Esto hace el script más claro y evita depender de configuración implícita.

### `session.table(...)`
Convierte una tabla o vista de Snowflake en un DataFrame Snowpark. Aquí no estamos trayendo datos a memoria local; estamos construyendo un objeto lógico que representa esa fuente.

### `filter(...)`
Aplica condiciones al DataFrame. La sintaxis es muy parecida a trabajar con PySpark. En este caso filtramos por:
- país;
- ciudad;
- año;
- mes.

### `group_by(...).agg(...)`
Agrupa por dimensiones y aplica agregaciones. Aquí tomamos el valor máximo de la velocidad del viento a 100 metros.

### `sort(...)`
Ordena la salida. En este caso elegimos fecha descendente para ver primero los días más recientes del período.

### `show(30)`
`show()` es una acción. Este punto es importante porque Snowpark trabaja con evaluación diferida.

---

## Concepto clave: lazy evaluation
Snowpark no ejecuta cada línea inmediatamente. Muchas operaciones, como `filter`, `group_by`, `agg` o `sort`, construyen un plan lógico. La ejecución real ocurre cuando se dispara una acción, como:
- `show()`
- `collect()`
- `count()`
- escritura a tabla o vista

Esto es importante porque:
- optimiza el plan antes de ejecutarlo;
- evita trabajo innecesario;
- mantiene el procesamiento dentro de Snowflake.

En términos prácticos:

> el script parece Python, pero el trabajo pesado lo hace Snowflake.

---

## Qué pasó internamente en Snowflake
Aunque nosotros escribimos Python, Snowpark traduce la lógica a operaciones que Snowflake puede ejecutar en su motor. Eso significa que:
- el warehouse realiza el cómputo;
- los datos no se procesan en RAM local;
- el resultado final se materializa en una vista dentro del esquema `harmonized`.

Esto es una de las ideas más poderosas de Snowpark: puedes desarrollar con Python, pero manteniendo la escalabilidad del motor de Snowflake.

---

## Resultados obtenidos
La salida mostró los valores máximos de velocidad de viento para Hamburg durante febrero de 2022. Por ejemplo:
- 2022-02-20: 47.7
- 2022-02-19: 66.5
- 2022-02-18: 60.2
- 2022-02-17: 55.0
- 2022-02-16: 51.6

Esto confirma que la lógica filtró correctamente por ciudad y período, y que la agregación funcionó como se esperaba.

Adicionalmente, la vista:

```text
tasty_bytes.harmonized.windspeed_hamburg_snowpark
```

quedó creada correctamente para reutilizarse en consultas posteriores.

---

## Qué aprendimos realmente
Esta lección no solo enseña sintaxis de Snowpark. También enseña una forma distinta de pensar las transformaciones:

- ya no todo depende de SQL;
- Python puede ser una interfaz de transformación sobre Snowflake;
- los DataFrames permiten una lógica más modular y legible;
- el cómputo sigue escalando porque se ejecuta dentro de Snowflake;
- el entorno local se convierte en un cliente de desarrollo, no en el motor de procesamiento.

---

## Conexión con data engineering real
En proyectos reales, Snowpark es útil cuando:
- queremos escribir pipelines o transformaciones en Python;
- necesitamos encapsular lógica reutilizable;
- trabajamos con equipos que dominan mejor Python que SQL;
- queremos combinar transformaciones, validaciones y lógica más avanzada;
- buscamos un puente natural entre data engineering, analytics engineering y machine learning.

Snowpark también ayuda a acercar el trabajo en Snowflake a prácticas más modernas de desarrollo:
- scripts versionables;
- modularidad;
- testing futuro;
- reusabilidad;
- integración con repositorios y CI/CD.

---

## Buenas prácticas identificadas en esta lección
1. **Usar conexión explícita** cuando el entorno local no tiene `default` configurado.
2. **Trabajar desde VS Code** para mantener un flujo reproducible.
3. **Usar nombres fully qualified** para tablas y vistas críticas.
4. **Separar lectura, filtrado, agregación y escritura** en pasos claros.
5. **Mantener el resultado en Snowflake** como vista reutilizable.
6. **Usar `.py` como entregable principal** cuando el objetivo es portafolio y versionamiento.

---

## Diferencia entre el notebook del curso y nuestra implementación

| Elemento | Curso | Proyecto práctico |
|---|---|---|
| Entorno | Snowflake Notebook | VS Code |
| Sesión | `get_active_session()` | `Session.builder.configs(...).create()` |
| Formato | `.ipynb` | `.py` |
| Enfoque | demostración guiada | práctica reproducible y versionable |

La lógica funcional es la misma. Lo que cambió fue la forma de ejecución para alinearla con un entorno profesional de trabajo.

---

## Conclusión
Snowpark amplía la forma en que podemos trabajar con datos en Snowflake. En vez de depender únicamente de SQL, permite construir transformaciones con Python mediante DataFrames, manteniendo el procesamiento dentro del motor de Snowflake. En esta lección validamos que esa promesa funciona en un entorno real de desarrollo desde VS Code, replicando con éxito la lógica del curso y dejando como resultado una vista reutilizable dentro del esquema `harmonized`.

En otras palabras, esta lección nos enseñó que:
- Snowflake no es solo SQL;
- Snowpark permite desarrollar con una mentalidad más programática;
- Python y Snowflake pueden integrarse de forma muy natural;
- el verdadero poder está en escribir lógica flexible sin perder escalabilidad.

---

## Aprendizajes clave
- Spark es un motor distribuido para procesamiento de datos.
- PySpark permite usar Spark con Python.
- Snowpark ofrece una experiencia parecida a DataFrames, pero ejecutada en Snowflake.
- En VS Code debemos crear la sesión explícitamente.
- Snowpark trabaja con evaluación diferida.
- El cómputo ocurre en Snowflake, no en la memoria local.
- Una transformación construida con SQL puede replicarse con Snowpark de forma clara y mantenible.

