-- =========================================================
-- 02_create_orders_header_sproc_original.sql
-- Versión: Original del curso
--
-- Objetivo:
--   Crear un stored procedure usando Snowpark for Python
--   para procesar el stream de order_header.
--
-- ¿Qué hace este stored procedure?
--   1. Lee el stream order_header_stream.
--   2. Filtra únicamente los registros nuevos de tipo INSERT.
--   3. Cruza esos pedidos con la tabla LOCATION.
--   4. Identifica pedidos realizados en Hamburg, Germany.
--   5. Agrupa las ventas por día.
--   6. Calcula la suma total de ventas.
--   7. Escribe el resultado en raw_pos.daily_sales_hamburg_t.
--   8. Devuelve un mensaje de éxito.
--
-- Importante:
--   Esta es la versión tal como viene en el archivo del curso.
--   Más abajo te dejaré una versión mejorada y más consistente
--   para usar en tu proyecto práctico.
-- =========================================================

CREATE OR REPLACE PROCEDURE tasty_bytes.raw_pos.process_order_headers_stream()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.10'
  HANDLER ='process_order_headers_stream'
  PACKAGES = ('snowflake-snowpark-python')
AS
$$
import snowflake.snowpark.functions as F
from snowflake.snowpark import Session

def process_order_headers_stream(session: Session) -> float:
    # -----------------------------------------------------
    # Paso 1: Leer el stream que captura cambios recientes
    # en la tabla order_header.
    #
    # Aquí el procedure no consulta toda la tabla histórica,
    # sino únicamente lo que el stream haya registrado como
    # cambio reciente.
    # -----------------------------------------------------
    recent_orders = session.table("order_header_stream").filter(F.col("METADATA$ACTION") == "INSERT")
    
    # -----------------------------------------------------
    # Paso 2: Consultar la tabla LOCATION para obtener los
    # datos geográficos de cada pedido.
    # -----------------------------------------------------
    locations = session.table("location")

    # -----------------------------------------------------
    # Paso 3: Hacer join entre los pedidos recientes y la
    # tabla de ubicaciones para identificar solamente los
    # pedidos de Hamburg, Germany.
    # -----------------------------------------------------
    hamburg_orders = recent_orders.join(
        locations,
        recent_orders["LOCATION_ID"] == locations["LOCATION_ID"]
    ).filter(
        (locations["CITY"] == "Hamburg") &
        (locations["COUNTRY"] == "Germany")
    )
    
    # -----------------------------------------------------
    # Paso 4: Agrupar por día usando ORDER_TS y sumar el
    # total de ventas del día.
    #
    # Si no hubiera ventas, coalesce asegura un 0 en lugar
    # de un valor nulo.
    # -----------------------------------------------------
    total_sales = hamburg_orders.group_by(F.date_trunc('DAY', F.col("ORDER_TS"))).agg(
        F.coalesce(F.sum("ORDER_TOTAL"), F.lit(0)).alias("total_sales")
    )
    
    # -----------------------------------------------------
    # Paso 5: Preparar el resultado final con nombres
    # más claros y con el campo de fecha convertido a DATE.
    # -----------------------------------------------------
    daily_sales = total_sales.select(
        F.col("DATE_TRUNC('DAY', ORDER_TS)").cast("DATE").alias("DATE"),
        F.col("total_sales")
    )
    
    # -----------------------------------------------------
    # Paso 6: Escribir los resultados en la tabla destino.
    #
    # Ojo:
    #   En el archivo original del curso se escribe
    #   "total_sales" en lugar de "daily_sales".
    #   Esto lo respetamos aquí porque esta es la versión
    #   original tal cual.
    # -----------------------------------------------------
    total_sales.write.mode("append").save_as_table("raw_pos.daily_sales_hamburg_t")
    
    # -----------------------------------------------------
    # Paso 7: Devolver un mensaje que indique que el proceso
    # terminó correctamente.
    # -----------------------------------------------------
    return "Daily sales for Hamburg, Germany have been successfully written to raw_pos.daily_sales_hamburg_t"
$$;