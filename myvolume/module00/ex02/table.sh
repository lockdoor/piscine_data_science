#!/bin/bash

PSQL="psql -X --username=$POSTGRES_USER --dbname=$POSTGRES_DB --tuples-only -c"

TABLE_NAME=$(basename "$1" .csv)

CREATE_TABLE(){
  # Check event_type enum exists
  EVENT_TYPE_EXISTS=$($PSQL "SELECT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'event_type');")

  if [[ $EVENT_TYPE_EXISTS == *f* ]]; then
    #Create event_type enum
    $PSQL "CREATE TYPE event_type AS ENUM ('view', 'cart', 'remove_from_cart', 'purchase');"
  fi

  # Create the table
  $PSQL "CREATE TABLE $TABLE_NAME (\
  event_time TIMESTAMPTZ NOT NULL, \
  event_type event_type default 'view' NOT NULL, \
  product_id INT NOT NULL, \
  price NUMERIC(10, 2) NOT NULL, \
  user_id INT NOT NULL, \
  user_session UUID, \
  id SERIAL PRIMARY KEY);"
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

$PSQL "\COPY $TABLE_NAME(event_time, event_type, product_id, price, user_id, user_session) FROM '$1' DELIMITER ',' CSV HEADER;"
