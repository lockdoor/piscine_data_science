#!/bin/bash

# automate create table form module00/subject/custome
/myvalume/module00/ex03/automatic_table.sh /myvalume/module00/subject/customer

# create table items from module00/subject/item/item.csv
/myvalume/module00/ex04/items_table.sh /myvalume/module00/subject/item/item.csv

# merge data table to customers
/myvalume/module01/ex01/customers_table.sh

# remove duplicates from table customers
/myvalume/module01/ex02/remove_duplicates.sh

# merge table items to table customers
/myvalume/module01/ex03/fusion.sh