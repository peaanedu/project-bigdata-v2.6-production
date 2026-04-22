CREATE DATABASE IF NOT EXISTS lab;
USE lab;
CREATE EXTERNAL TABLE IF NOT EXISTS sales_orders (
  order_id INT,
  order_date DATE,
  region STRING,
  product_category STRING,
  product_name STRING,
  customer_name STRING,
  quantity INT,
  unit_price DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/data/raw/sales'
TBLPROPERTIES ('skip.header.line.count'='1');
