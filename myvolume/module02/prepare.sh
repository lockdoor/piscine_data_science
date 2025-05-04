#!/bin/bash

# cause the subject not use database from February 2023
# shold Drop all tables and move data_2023_feb.csv out the directory

# Drop all tables
PSQL="psql -X --username=$POSTGRES_USER --dbname=$POSTGRES_DB --tuples-only -c"
TABLES=$($PSQL "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';")

for TABLE in $TABLES; do
  echo "Dropping table $TABLE"
  $PSQL "DROP TABLE IF EXISTS $TABLE;"
done

# automate create table form myvolume/subject/customer
/myvolume/module00/ex03/automatic_table.sh /myvolume/subject/customer

# create table items from myvolume/subject/item/item.csv
/myvolume/module00/ex04/items_table.sh /myvolume/subject/item/item.csv

# merge data table to customers
/myvolume/module01/ex01/customers_table.sh

# remove duplicates from table customers
/myvolume/module01/ex02/remove_duplicates.sh

# merge table items to table customers
/myvolume/module01/ex03/fusion.sh