# Cradit
- [Statistic](https://www.youtube.com/@ThanutWongsaichue)
- [Machine Learning](https://www.youtube.com/playlist?list=PLoTScYm9O0GH_3VrwwnQafwWQ6ibKnEtU)

psql -U pnamnil -d piscineds -h localhost -W

on localhost password not reqired

1. automate create table form module00/subject/customer
```
/myvalume/module00/ex03/automatic_table.sh /myvalume/module00/subject/customer
```

2. create table items from module00/subject/item/item.csv
```
/myvalume/module00/ex04/items_table.sh /myvalume/module00/subject/item/item.csv
```

3. merge data table to customers
```
/myvalume/module01/ex01/customers_table.sh
```

4. remove duplicates from table customers
```
/myvalume/module01/ex02/remove_duplicates.sh
```

5. merge table items to table customers
```
/myvalume/module01/ex03/fusion.sh
```