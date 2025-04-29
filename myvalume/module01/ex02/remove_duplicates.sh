#!/bin/bash

# THIS SCRIPT REMOVES DUPLICATE RECORDS FROM A TABLE
# The field names are:

#                                        Table "public.customers"
#    Column    |           Type           | Collation | Nullable |                Default                
#--------------+--------------------------+-----------+----------+---------------------------------------
# event_time   | timestamp with time zone |           | not null | 
# event_type   | event_type               |           | not null | 'view'::event_type
# product_id   | integer                  |           | not null | 
# price        | numeric(10,2)            |           | not null | 
# user_id      | integer                  |           | not null | 
# user_session | uuid                     |           |          | 
# id           | integer                  |           | not null | nextval('customers_id_seq'::regclass)
#Indexes:
#    "customers_pkey" PRIMARY KEY, btree (id)


# piscineds=# SELECT product_id, user_id, event_type, user_session, COUNT(user_session) 
# FROM customers 
# GROUP BY user_id, product_id, event_type, event_type, user_session
# HAVING COUNT(user_session) > 1 AND event_type = 'remove_from_cart' LIMIT 10;
#  product_id | user_id  |    event_type    |           user_session_id            | count 
# ------------+----------+------------------+--------------------------------------+-------
#     5709126 |  8846226 | remove_from_cart | f835c9a8-cb8a-4201-85d4-00565bcc84ad |     2
#     5739036 |  8846226 | remove_from_cart | ddd23270-792c-49f3-9ae2-d86f5080a5eb |     2
#     5812138 |  8846226 | remove_from_cart | ddd23270-792c-49f3-9ae2-d86f5080a5eb |     2
#     5823668 |  8846226 | remove_from_cart | f835c9a8-cb8a-4201-85d4-00565bcc84ad |     2
#     5724305 |  9794320 | remove_from_cart | 30d70cc3-86ee-4b5d-879c-40f06132163c |     2
#     5811704 |  9794320 | remove_from_cart | 30d70cc3-86ee-4b5d-879c-40f06132163c |     2
#     5844670 |  9794320 | remove_from_cart | 1be8fa80-8036-4d95-93da-494a08d82cb5 |     2
#     5896605 |  9794320 | remove_from_cart | 5a5f1fe8-f54f-4524-8406-c9718fd05c5a |     2
#     5896606 |  9794320 | remove_from_cart | 5a5f1fe8-f54f-4524-8406-c9718fd05c5a |     2
#     5807805 | 10280338 | remove_from_cart | fbacb4a3-2141-4f43-b9e5-97c911c7e770 |     2
# (10 rows)

# piscineds=# SELECT * FROM customers WHERE user_session = 'f835c9a8-cb8a-4201-85d4-00565bcc84ad';
#        event_time       |    event_type    | product_id | price | user_id |           user_session_id            |   id    
# ------------------------+------------------+------------+-------+---------+--------------------------------------+---------
#  2022-10-02 14:13:23+00 | cart             |    5857896 |  2.78 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8430615
#->  2022-10-02 14:14:02+00 | view             |    5827351 |  4.92 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8430731
#->  2022-10-02 14:15:27+00 | cart             |    5827351 |  4.92 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8430914
#  2022-10-02 14:17:18+00 | cart             |    5875372 |  2.05 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8431203
#  2022-10-02 14:18:05+00 | cart             |    5875774 |  2.05 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8431334
#  2022-10-02 14:24:37+00 | cart             |    5783523 |  2.06 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8432359
#  2022-10-02 14:25:55+00 | cart             |    5696858 |  1.11 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8432572
#  2022-10-02 14:28:12+00 | cart             |    5810719 |  1.27 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8432916
#  2022-10-02 14:34:09+00 | view             |    5889616 |  2.14 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8433837
#  2022-10-02 14:38:19+00 | view             |    5882900 |  7.33 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8434481
#  2022-10-02 14:40:53+00 | cart             |    5802678 |  3.83 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8434911
#  2022-10-02 14:42:35+00 | view             |    5785589 |  7.92 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8435169
#->  2022-10-02 14:43:55+00 | remove_from_cart |    5709126 |  4.21 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8435377
#->  2022-10-02 14:43:55+00 | remove_from_cart |    5709126 |  4.21 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8435380
#  2022-10-02 14:44:14+00 | remove_from_cart |    5875372 |  2.05 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8435428
#  2022-10-02 14:44:40+00 | remove_from_cart |    5823669 |  8.56 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8435504
#->  2022-10-02 14:44:45+00 | remove_from_cart |    5823668 |  7.60 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8435517
#->  2022-10-02 14:44:45+00 | remove_from_cart |    5823668 |  7.60 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8435520
#  2022-10-02 14:45:01+00 | remove_from_cart |    5739057 |  4.75 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8435558
#  2022-10-02 14:45:38+00 | remove_from_cart |    5810719 |  1.27 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8435660
#  2022-10-02 14:48:37+00 | remove_from_cart |    5783523 |  2.06 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad | 8436123
# (21 rows)

# I think product_id, user_id, user_session Should be unique multiple feild, 
# if it have duplicate records it should be update feild event_time and event_type

# piscineds=# SELECT DISTINCT ON (product_id, user_id, user_session, event_type) event_time, event_type, product_id, price, user_id, user_session 
# FROM customers where user_session='f835c9a8-cb8a-4201-85d4-00565bcc84ad';

#        event_time       |    event_type    | product_id | price | user_id |             user_session             
# ------------------------+------------------+------------+-------+---------+--------------------------------------
#  2022-10-02 14:25:55+00 | cart             |    5696858 |  1.11 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#->  2022-10-02 14:43:55+00 | remove_from_cart |    5709126 |  4.21 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:45:01+00 | remove_from_cart |    5739057 |  4.75 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:48:37+00 | remove_from_cart |    5783523 |  2.06 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:42:35+00 | view             |    5785589 |  7.92 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:40:53+00 | cart             |    5802678 |  3.83 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:45:38+00 | remove_from_cart |    5810719 |  1.27 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#->  2022-10-02 14:44:45+00 | remove_from_cart |    5823668 |  7.60 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:44:40+00 | remove_from_cart |    5823669 |  8.56 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#->  2022-10-02 14:14:02+00 | view             |    5827351 |  4.92 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:13:23+00 | cart             |    5857896 |  2.78 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:44:14+00 | remove_from_cart |    5875372 |  2.05 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:18:05+00 | cart             |    5875774 |  2.05 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:38:19+00 | view             |    5882900 |  7.33 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:34:09+00 | view             |    5889616 |  2.14 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
# (15 rows)

# If event_type shuld be unique multiple feild,
# piscineds=# SELECT DISTINCT ON (product_id, user_id, user_session, event_type) event_time, event_type, product_id, price, user_id, user_session 
# FROM customers where user_session='f835c9a8-cb8a-4201-85d4-00565bcc84ad';
#        event_time       |    event_type    | product_id | price | user_id |             user_session             
# ------------------------+------------------+------------+-------+---------+--------------------------------------
#  2022-10-02 14:25:55+00 | cart             |    5696858 |  1.11 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#->  2022-10-02 14:43:55+00 | remove_from_cart |    5709126 |  4.21 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:45:01+00 | remove_from_cart |    5739057 |  4.75 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:24:37+00 | cart             |    5783523 |  2.06 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:48:37+00 | remove_from_cart |    5783523 |  2.06 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:42:35+00 | view             |    5785589 |  7.92 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:40:53+00 | cart             |    5802678 |  3.83 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:28:12+00 | cart             |    5810719 |  1.27 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:45:38+00 | remove_from_cart |    5810719 |  1.27 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#->  2022-10-02 14:44:45+00 | remove_from_cart |    5823668 |  7.60 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:44:40+00 | remove_from_cart |    5823669 |  8.56 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#->  2022-10-02 14:14:02+00 | view             |    5827351 |  4.92 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#->  2022-10-02 14:15:27+00 | cart             |    5827351 |  4.92 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:13:23+00 | cart             |    5857896 |  2.78 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:17:18+00 | cart             |    5875372 |  2.05 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:44:14+00 | remove_from_cart |    5875372 |  2.05 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:18:05+00 | cart             |    5875774 |  2.05 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:38:19+00 | view             |    5882900 |  7.33 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
#  2022-10-02 14:34:09+00 | view             |    5889616 |  2.14 | 8846226 | f835c9a8-cb8a-4201-85d4-00565bcc84ad
# (19 rows)

PSQL="psql -X --username=$POSTGRES_USER --dbname=$POSTGRES_DB --tuples-only -c"

# DROP TABLE customers IF EXISTS
$PSQL "DROP TABLE IF EXISTS customers_new;"

# CREATE NEW TABLE FOR INSERT NOT DUPLICATE RECORDS
$PSQL "CREATE TABLE customers_new(\
event_time TIMESTAMPTZ NOT NULL, \
event_type event_type default 'view' NOT NULL, \
product_id INT NOT NULL, \
price NUMERIC(10, 2) NOT NULL, \
user_id INT NOT NULL, \
user_session UUID, \
id SERIAL PRIMARY KEY);"

# ADD UNIQUE CONSTRAINT
# $PSQL "ALTER TABLE customers_new ADD CONSTRAINT unique_product_user_session UNIQUE (product_id, user_id, user_session);"

# INSERT NOT DUPLICATE RECORDS
# $PSQL "INSERT INTO customers_new (event_time, event_type, product_id, price, user_id, user_session) \
# SELECT DISTINCT ON (product_id, user_id, user_session, event_type) event_time, event_type, product_id, price, user_id, user_session FROM customers;"

$PSQL "WITH cte AS (
  SELECT
    *,
    LAG(event_time) OVER (
      PARTITION BY product_id, event_type
      ORDER BY event_time
    ) AS prev_event_time
  FROM customers
),
filtered AS (
  SELECT *
  FROM cte
  WHERE
    prev_event_time IS NULL  -- no previous = keep
    OR EXTRACT(EPOCH FROM (event_time - prev_event_time)) > 1 -- difference > 1 second = keep
)
INSERT INTO customers_new (event_time, event_type, product_id, price, user_id, user_session) \
SELECT event_time, event_type, product_id, price, user_id, user_session \
FROM filtered;"


# DROP TABLE customers;
# $PSQL "DROP TABLE IF EXISTS customers;"

# RENAME TABLE customers_new TO customers;"
# $PSQL "ALTER TABLE customers_new RENAME TO customers;"
