#!/bin/bash

PSQL="psql -X --username=$POSTGRES_USER --dbname=$POSTGRES_DB --tuples-only -c"

# DROP TABLE customers IF EXISTS
$PSQL "DROP TABLE IF EXISTS customers;"

# SELECT ALL TABLES NAME data_202*
TABLES=$($PSQL "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name LIKE 'data_202%';")

echo $TABLES

# Create the table
$PSQL "CREATE TABLE customers (\
event_time TIMESTAMPTZ NOT NULL, \
event_type event_type default 'view' NOT NULL, \
product_id INT NOT NULL, \
price NUMERIC(10, 2) NOT NULL, \
user_id INT NOT NULL, \
user_session UUID, \
id SERIAL PRIMARY KEY);"

# Loop through each table and copy data
for TABLE in $TABLES; do
  echo "Copying data from $TABLE to customers"
  $PSQL "INSERT INTO customers(event_time, event_type, product_id, price, user_id, user_session) \
  SELECT event_time, event_type, product_id, price, user_id, user_session FROM $TABLE;"
done
