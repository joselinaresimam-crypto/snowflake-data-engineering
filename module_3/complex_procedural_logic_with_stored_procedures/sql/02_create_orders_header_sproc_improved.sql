-- =========================================================
-- 02_create_orders_header_sproc_improved.sql
-- Versión: Mejorada para proyecto práctico
--
-- Objetivo:
--   Crear un stored procedure más consistente y limpio para
--   procesar el stream de order_header usando Snowpark Python.
--
-- Mejoras respecto a la versión original:
--   1. El tipo de retorno Python ahora coincide con RETURNS STRING.
--   2. Se escribe el dataframe final "daily_sales" y no el
--      dataframe intermedio "total_sales".
--   3. Los alias se manejan de forma más clara.
--   4. El código queda mejor preparado para documentación,
--      mantenimiento y portafolio.
-- =========================================================

CREATE OR REPLACE PROCEDURE tasty_bytes.raw_pos.process_order_headers_stream()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.10'
  HANDLER = 'process_order_headers_stream'
  PACKAGES = ('snowflake-snowpark-python')
AS
$$
import snowflake.snowpark.functions as F
from snowflake.snowpark import Session

def process_order_headers_stream(session: Session) -> str:
    # =====================================================
    # Paso 1. Leer el stream de la tabla order_header
    # -----------------------------------------------------
    # El stream contiene cambios capturados desde la tabla
    # origen. En este caso filtramos solo eventos de tipo
    # INSERT para procesar únicamente nuevos pedidos.
    # =====================================================
    recent_orders = session.table("order_header_stream").filter(
        F.col("METADATA$ACTION") == "INSERT"
    )

    # =====================================================
    # Paso 2. Cargar tabla de ubicaciones
    # -----------------------------------------------------
    # Esta tabla se utiliza para enriquecer los pedidos con
    # información geográfica y así identificar cuáles fueron
    # realizados en Hamburg, Germany.
    # =====================================================
    locations = session.table("location")

    # =====================================================
    # Paso 3. Unir pedidos recientes con ubicaciones
    # -----------------------------------------------------
    # Se hace join por LOCATION_ID para identificar la ciudad
    # y el país de cada pedido.
    #
    # Después filtramos específicamente:
    #   CITY = Hamburg
    #   COUNTRY = Germany
    # =====================================================
    hamburg_orders = recent_orders.join(
        locations,
        recent_orders["LOCATION_ID"] == locations["LOCATION_ID"]
    ).filter(
        (locations["CITY"] == "Hamburg") &
        (locations["COUNTRY"] == "Germany")
    )

    # =====================================================
    # Paso 4. Agregar ventas por día
    # -----------------------------------------------------
    # Truncamos ORDER_TS al nivel día para obtener un resumen
    # diario y luego sumamos ORDER_TOTAL.
    #
    # Si no hubiera registros, coalesce protege de nulos.
    # =====================================================
    total_sales = hamburg_orders.group_by(
        F.date_trunc("DAY", F.col("ORDER_TS"))
    ).agg(
        F.coalesce(F.sum("ORDER_TOTAL"), F.lit(0)).alias("TOTAL_SALES")
    )

    # =====================================================
    # Paso 5. Dar forma final al resultado
    # -----------------------------------------------------
    # Aquí preparamos el dataframe final que se escribirá a
    # la tabla destino:
    #   - Convertimos la fecha al tipo DATE
    #   - Dejamos un alias claro para el monto agregado
    # =====================================================
    daily_sales = total_sales.select(
        F.col("DATE_TRUNC('DAY', ORDER_TS)").cast("DATE").alias("DATE"),
        F.col("TOTAL_SALES")
    )

    # =====================================================
    # Paso 6. Escribir en tabla destino
    # -----------------------------------------------------
    # Guardamos el resultado final en una tabla que servirá
    # como salida del procesamiento del stream.
    #
    # mode("append"):
    #   agrega nuevos resultados sin sobrescribir los previos.
    # =====================================================
    daily_sales.write.mode("append").save_as_table(
        "raw_pos.daily_sales_hamburg_t"
    )

    # =====================================================
    # Paso 7. Devolver mensaje de éxito
    # -----------------------------------------------------
    # Esto ayuda a confirmar que el stored procedure terminó
    # su ejecución correctamente.
    # =====================================================
    return (
        "Daily sales for Hamburg, Germany have been successfully "
        "written to raw_pos.daily_sales_hamburg_t"
    )
$$;