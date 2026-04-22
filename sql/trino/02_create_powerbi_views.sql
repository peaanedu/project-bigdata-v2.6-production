CREATE OR REPLACE VIEW hive.powerbi.v_sales_orders AS
SELECT
  order_id,
  order_date,
  region,
  product_category,
  product_name,
  customer_name,
  quantity,
  unit_price,
  quantity * unit_price AS sales_amount
FROM hive.lab.sales_orders;

CREATE OR REPLACE VIEW hive.powerbi.v_sales_summary AS
SELECT
  region,
  product_category,
  CAST(date_trunc('month', order_date) AS date) AS sales_month,
  SUM(quantity) AS total_qty,
  SUM(quantity * unit_price) AS total_sales
FROM hive.lab.sales_orders
GROUP BY 1,2,3;
