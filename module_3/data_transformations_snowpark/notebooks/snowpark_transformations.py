from snowflake.snowpark import Session
from snowflake.snowpark.functions import col, max as sp_max, year, month

# Crear sesión usando la conexión configurada en Snowflake CLI
connection_parameters = {
    "connection_name": "modern_data_engineering_snowflake"
}

session = Session.builder.configs(connection_parameters).create()

print("Conexión exitosa a Snowflake")

# Cargar la vista base
daily_weather = session.table("tasty_bytes.harmonized.daily_weather_v")

# Filtrar Alemania, Hamburg, febrero 2022
filtered_weather = daily_weather.filter(
    (col("country_desc") == "Germany") &
    (col("city_name") == "Hamburg") &
    (year(col("date_valid_std")) == 2022) &
    (month(col("date_valid_std")) == 2)
)

# Agrupar y calcular máxima velocidad de viento
aggregated_weather = filtered_weather.group_by(
    "country_desc", "city_name", "date_valid_std"
).agg(
    sp_max("max_wind_speed_100m_mph").alias("max_wind_speed_100m_mph")
)

# Ordenar resultados por fecha descendente
sorted_weather = aggregated_weather.sort(col("date_valid_std").desc())

# Mostrar resultados
sorted_weather.show(30)

# Crear o reemplazar vista final
sorted_weather.create_or_replace_view(
    "tasty_bytes.harmonized.windspeed_hamburg_snowpark"
)

print("Vista creada correctamente: tasty_bytes.harmonized.windspeed_hamburg_snowpark")