#!/bin/bash

PSQL="psql -X --username=$POSTGRES_USER --dbname=$POSTGRES_DB --tuples-only -c"

# TABLE_NAME=$(basename "$1" .csv)
TABLE_NAME=items

CREATE_TABLE(){
  # Create the table
  $PSQL "CREATE TABLE $TABLE_NAME (\
  product_id INT NOT NULL, \
  category_id BIGINT, \
  category_code VARCHAR, \
  brand VARCHAR);"
}

#### Main Program ####

# Check the file is csv
if [[ $1 != *.csv ]]; then
  echo "Required csv file"
  exit 1
fi

# Check the file exists
if [ ! -f "$1" ]; then
  echo "File does not exist"
  exit 1
fi

$PSQL "DROP TABLE IF EXISTS $TABLE_NAME;"
CREATE_TABLE

$PSQL "\COPY $TABLE_NAME(product_id, category_id, category_code, brand) FROM '$1' DELIMITER ',' CSV HEADER;"