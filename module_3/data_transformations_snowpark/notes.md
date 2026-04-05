# Notes — Data transformations with Snowpark

## Resumen ejecutivo
Snowpark es la capa de desarrollo programática de Snowflake para transformar datos con **Python, Java o Scala** usando una API de DataFrames. Su valor principal es que permite escribir lógica más flexible que SQL tradicional, pero manteniendo el procesamiento dentro de Snowflake. En esta lección adaptamos el ejercicio del curso desde un **Snowflake Notebook** a un script **Python ejecutado en VS Code**, conectándonos mediante Snowflake CLI y creando una vista con los máximos de velocidad de viento para Hamburg, Germany, en febrero de 2022.

---

## Idea central de la lección
El curso busca demostrar que una transformación hecha previamente en SQL también puede hacerse con Snowpark. El objetivo no es reemplazar SQL por completo, sino mostrar otra forma de construir transformaciones:

- más programática,
- más modular,
- más cercana a prácticas de ingeniería,
- y sin mover el procesamiento fuera de Snowflake.

---

## Qué es importante entender de fondo

### 1. Snowpark no procesa localmente
Aunque el código se escribe en Python, eso no significa que Python procese los datos en tu laptop. Snowpark construye un plan lógico y empuja la ejecución a Snowflake. El warehouse sigue siendo quien realiza el trabajo pesado.

### 2. Snowpark se parece a PySpark en experiencia, no en arquitectura
La similitud principal está en la API de DataFrames y en el estilo de trabajo:
- `filter`
- `group_by`
- `agg`
- `sort`

Pero la arquitectura es distinta. En PySpark el motor es Spark. En Snowpark el motor es Snowflake.

### 3. El verdadero valor está en la flexibilidad
Snowpark es especialmente útil cuando SQL empieza a volverse muy largo, difícil de mantener o poco reusable. Con Python se pueden encapsular mejor pasos, funciones y patrones de transformación.

---

## Problema técnico que resolvimos
Inicialmente el script falló porque `Session.builder.getOrCreate()` buscó una conexión por defecto llamada `default`. Esa conexión no estaba configurada.

El error fue:

```text
Connection default is not configured
```

La solución fue identificar la conexión correcta ya existente y declararla explícitamente:

```python
connection_parameters = {
    "connection_name": "modern_data_engineering_snowflake"
}
```

Con eso, la sesión pudo crearse correctamente desde VS Code.

---

## Diferencia entre usar Snowflake Notebook y VS Code

### En Snowflake Notebook
El entorno ya trae una sesión activa y el código puede usar:

```python
get_active_session()
```

### En VS Code
Tenemos que crear la sesión nosotros mismos usando la conexión de Snowflake CLI.

Esto es importante porque muestra una diferencia real entre un entorno guiado por UI y un entorno profesional de desarrollo local.

---

## Vista usada como fuente
Se trabajó con:

```text
tasty_bytes.harmonized.daily_weather_v
```

Esta vista ya contiene datos climáticos organizados y listos para ser transformados. En esta lección no fue necesario hacer exploración extensa porque el foco estaba en practicar Snowpark y no en redescubrir el dataset.

---

## Transformación implementada
La lógica aplicada fue:

1. cargar la vista como DataFrame;
2. filtrar por `Germany` y `Hamburg`;
3. restringir a febrero de 2022;
4. agrupar por país, ciudad y fecha;
5. calcular el máximo de `max_wind_speed_100m_mph`;
6. ordenar por fecha descendente;
7. escribir el resultado en una vista.

La vista generada fue:

```text
tasty_bytes.harmonized.windspeed_hamburg_snowpark
```

---

## Interpretación de resultados
El resultado mostró una serie diaria con los máximos de velocidad de viento en Hamburg durante febrero de 2022. Los valores más altos observados en la salida incluyeron días con intensidades relevantes como 66.5, 60.2 y 55.0 mph, lo que confirma que la agregación está capturando correctamente el máximo diario para el período filtrado.

Más allá del dato específico, lo importante es que:
- el filtro funcionó correctamente,
- la agregación fue consistente,
- el ordenamiento quedó aplicado,
- y la vista final quedó lista para consumo posterior.

---

## Aprendizaje técnico más importante
El aprendizaje más importante no fue solo la sintaxis de Snowpark, sino este cambio mental:

> Python puede ser la interfaz de transformación, pero Snowflake sigue siendo el motor de ejecución.

Eso permite combinar lo mejor de ambos mundos:
- expresividad de Python,
- escalabilidad de Snowflake.

---

## Cuándo conviene Snowpark
Snowpark conviene especialmente cuando:
- se necesita lógica más compleja que un SQL sencillo;
- se quiere mantener el código modular y reusable;
- el equipo trabaja mucho con Python;
- se quiere preparar el camino para UDFs, stored procedures o pipelines más avanzados;
- se busca acercar el trabajo de transformación a un flujo de ingeniería más completo.

---

## Cuándo SQL sigue siendo suficiente
SQL sigue siendo excelente cuando:
- la transformación es clara y declarativa;
- el problema es principalmente de joins, filtros, agregaciones simples;
- la mantenibilidad todavía es alta;
- el equipo trabaja naturalmente con SQL.

La lección no plantea una competencia entre SQL y Snowpark, sino una ampliación del toolkit.

---

## Conexión con lo que viene después
Esta lección prepara el camino para temas más avanzados como:
- funciones reutilizables,
- user-defined functions,
- lógica programática reutilizable,
- pipelines más estructurados,
- transformaciones mantenibles a mayor escala.

Entender Snowpark aquí es importante porque más adelante dejará de ser solo una forma distinta de filtrar datos y pasará a convertirse en una herramienta de diseño de soluciones de datos dentro de Snowflake.

---

## Buenas prácticas derivadas
- Preferir scripts `.py` para entregables versionables.
- Usar conexiones explícitas en entornos locales.
- Mantener nombres totalmente calificados para tablas y vistas relevantes.
- Separar el flujo en etapas claras: lectura, filtro, agregación, salida.
- Guardar resultados como vistas o tablas según el caso de uso.
- Documentar diferencias entre entorno del curso y entorno real de trabajo.

---

## Cierre
Snowpark representa una evolución natural para quienes ya trabajan con SQL en Snowflake pero quieren incorporar una capa programática más potente. En esta práctica vimos que no solo es una idea teórica: la conexión local, el script en VS Code y la creación de la vista final demostraron que Snowpark puede integrarse sin fricción a un flujo de trabajo real de data engineering.

La lección deja una idea muy valiosa para el portafolio:

> no solo sabemos ejecutar transformaciones en Snowflake; también sabemos traducirlas de un entorno guiado del curso a una implementación reproducible y profesional.

