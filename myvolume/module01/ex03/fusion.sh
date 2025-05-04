#!/bin/bash

PSQL="psql -X --username=$POSTGRES_USER --dbname=$POSTGRES_DB --tuples-only -c"

# This script merge table customer and table items
# into a new table called customers_items

# DROP the table customers_items if it exists
$PSQL "DROP TABLE IF EXISTS customers_items;"

# COPY table customers into customers_items
$PSQL "CREATE TABLE customers_items AS TABLE customers;"

$PSQL "ALTER TABLE customers_items ADD COLUMN category_id BIGINT;"
$PSQL "ALTER TABLE customers_items ADD COLUMN category_code VARCHAR;"
$PSQL "ALTER TABLE customers_items ADD COLUMN brand VARCHAR;"

# MERGE table items into customers_items
$PSQL "MERGE INTO customers_items AS c \
USING ( \
  SELECT DISTINCT ON (product_id) *
  FROM items \
  ORDER BY product_id, category_id \
  ) AS i \
ON (c.product_id = i.product_id) \
WHEN MATCHED THEN \
  UPDATE SET \
    category_id = i.category_id, \
    category_code = i.category_code, \
    brand = i.brand;"

# DROP table customers
$PSQL "DROP TABLE IF EXISTS customers;"

# RENAME table customers_items to customers
$PSQL "ALTER TABLE customers_items RENAME TO customers;"
