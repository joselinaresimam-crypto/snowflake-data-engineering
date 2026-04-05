
-- ########################################
-- Validamos que la base y schemas existen
-- ########################################
SHOW DATABASES LIKE 'TASTY_BYTES';
SHOW SCHEMAS IN DATABASE TASTY_BYTES;

-- ########################################################
-- Validar que las tablas raw existen y tienen registros
-- ########################################################
USE DATABASE TASTY_BYTES;
SHOW TABLES IN SCHEMA RAW_POS;
SHOW TABLES IN SCHEMA RAW_CUSTOMER;


SELECT 'country' AS table_name, COUNT(*) AS row_count FROM TASTY_BYTES.RAW_POS.COUNTRY
UNION ALL
SELECT 'franchise', COUNT(*) FROM TASTY_BYTES.RAW_POS.FRANCHISE
UNION ALL
SELECT 'location', COUNT(*) FROM TASTY_BYTES.RAW_POS.LOCATION
UNION ALL
SELECT 'menu', COUNT(*) FROM TASTY_BYTES.RAW_POS.MENU
UNION ALL
SELECT 'truck', COUNT(*) FROM TASTY_BYTES.RAW_POS.TRUCK
UNION ALL
SELECT 'order_header', COUNT(*) FROM TASTY_BYTES.RAW_POS.ORDER_HEADER
UNION ALL
SELECT 'order_detail', COUNT(*) FROM TASTY_BYTES.RAW_POS.ORDER_DETAIL
UNION ALL
SELECT 'customer_loyalty', COUNT(*) FROM TASTY_BYTES.RAW_CUSTOMER.CUSTOMER_LOYALTY
ORDER BY table_name;

-- ###############################################
-- Validar que las vistas también quedaron bien
-- ###############################################

SHOW VIEWS IN SCHEMA TASTY_BYTES.HARMONIZED;
SHOW VIEWS IN SCHEMA TASTY_BYTES.ANALYTICS;

SELECT COUNT(*) AS harmonized_orders_count
FROM TASTY_BYTES.HARMONIZED.ORDERS_V;

SELECT COUNT(*) AS harmonized_customer_loyalty_metrics_count
FROM TASTY_BYTES.HARMONIZED.CUSTOMER_LOYALTY_METRICS_V;

SELECT COUNT(*) AS analytics_orders_count
FROM TASTY_BYTES.ANALYTICS.ORDERS_V;

SELECT COUNT(*) AS analytics_customer_loyalty_metrics_count
FROM TASTY_BYTES.ANALYTICS.CUSTOMER_LOYALTY_METRICS_V;

-- #################################################
-- Validación funcional rápida del caso del curso
-- #################################################

SELECT
    primary_city,
    country,
    COUNT(*) AS total_rows
FROM TASTY_BYTES.HARMONIZED.ORDERS_V
WHERE UPPER(primary_city) = 'HAMBURG'
  AND UPPER(country) = 'GERMANY'
GROUP BY primary_city, country;

-- ##################################
-- Validación exploratoria corta
-- ##################################

SELECT * 
FROM TASTY_BYTES.RAW_POS.TRUCK
LIMIT 10;

SELECT * 
FROM TASTY_BYTES.ANALYTICS.ORDERS_V
LIMIT 10;

