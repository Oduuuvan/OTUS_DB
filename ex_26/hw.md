### Реализация полнотекстового индекса.
Создал таблицу
```
USE school;

CREATE TABLE product
(
	product_id integer PRIMARY KEY,
	name varchar(200),
	description text
)ENGINE=INNODB;
```
Наполнил данными
```
LOAD DATA LOCAL INFILE '/var/tmp/product.csv'  INTO TABLE product  FIELDS TERMINATED BY ','  ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
```
Создал индекс
```
CREATE FULLTEXT INDEX fulltext_idx_name_description ON product (name, description);
```
Запрос
```
EXPLAIN 
SELECT 
	name,
	description
FROM product p
WHERE MATCH(name, description) AGAINST('orange');

/*
С индексом
|id |select_type|table|partitions|type    |possible_keys                |key                          |key_len|ref  |rows|filtered|Extra                        |
|---|-----------|-----|----------|--------|-----------------------------|-----------------------------|-------|-----|----|--------|-----------------------------|
|1  |SIMPLE     |p    |          |fulltext|fulltext_idx_name_description|fulltext_idx_name_description|0      |const|1   |100.0   |Using where; Ft_hints: sorted|

Без индекса
SQL Error [1191] [HY000]: Can't find FULLTEXT index matching the column list
*/
```
### Добавляем или обновляем индексы
```
-- Изменил индекс, т.к. чаще будет использоваться поиск с функцией UPPER
CREATE INDEX idx_upper_fio ON school.users ((UPPER(name)), (UPPER(surname)), (UPPER(patronymic)));

-- Добавил индексы на уникальность полей
ALTER TABLE users ADD CONSTRAINT u_username UNIQUE (username);
ALTER TABLE users ADD CONSTRAINT u_mail UNIQUE (mail);
```