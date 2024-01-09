### группировки с ипользованием CASE, HAVING, ROLLUP, GROUPING(); Для магазина к предыдущему списку продуктов добавить максимальную и минимальную цену и кол-во предложений; Сделать выборку показывающую самый дорогой и самый дешевый товар в каждой категории; Сделать rollup с количеством товаров по категориям
Создал таблицы и наполнил их данными
```
CREATE TABLE IF NOT EXISTS school.product 
(
	product_id integer UNSIGNED PRIMARY KEY,
	product_name varchar(200),
	price decimal,
	quantity integer UNSIGNED,
	category_id integer UNSIGNED,
	FOREIGN KEY (category_id) REFERENCES school.category (category_id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS school.category 
(
	category_id integer UNSIGNED PRIMARY KEY,
	category_name varchar(200)
) ENGINE=INNODB;

INSERT INTO school.category VALUES (1, 'Молочный продукт');
INSERT INTO school.category VALUES (2, 'Выпечка');
INSERT INTO school.category VALUES (3, 'Фрукты и овощи');
INSERT INTO school.category VALUES (4, 'Мясной продукт');


INSERT INTO school.product VALUES (1, 'Молоко', 60, 10, 1);
INSERT INTO school.product VALUES (2, 'Сыр', 100, 11, 1);
INSERT INTO school.product VALUES (3, 'Сыр подороже', 200, 5, 1);
INSERT INTO school.product VALUES (4, 'Булка', 25, 15, 2);
INSERT INTO school.product VALUES (5, 'Хлеб', 19, 30, 2);
INSERT INTO school.product VALUES (6, 'Яблоки', 50, 6, 3);
INSERT INTO school.product VALUES (7, 'Бананы', 110, 5, 3);
INSERT INTO school.product VALUES (8, 'мандарины', 125, 5, 3);
INSERT INTO school.product VALUES (9, 'Киви', 210, 4, 3);
INSERT INTO school.product VALUES (10, 'Колбаса', 300, 8, 4);
INSERT INTO school.product VALUES (11, 'Сосиски', 130, 10, 4);
INSERT INTO school.product VALUES (12, 'Куриная грудка', 400, 9, 4);
INSERT INTO school.product VALUES (13, 'Стейк', 1500, 1, 4);
INSERT INTO school.product VALUES (14, 'Дорогущий стейк', 3500, null, 4);
```
Запрос, который используюет все перечисленное в задании
```
WITH cte AS (
	SELECT 
		p.product_name,
		p.price,
		CASE WHEN p.quantity IS NULL THEN 0 ELSE p.quantity END quantity,
		c.category_name
	FROM product p 
	JOIN category c ON c.category_id = p.category_id 
)
SELECT 
	IF (GROUPING (category_name), 'Итого:', category_name) category_name, 
	sum(quantity) sum_quantity,
	max(price) max_price,
	min(price) min_price
FROM cte
GROUP BY category_name WITH ROLLUP
HAVING sum_quantity > 25;

/*
|category_name   |sum_quantity|max_price|min_price|
|----------------|------------|---------|---------|
|Выпечка         |45          |25       |19       |
|Молочный продукт|26          |200      |60       |
|Мясной продукт  |28          |3500     |130      |
|Итого:          |119         |3500     |19       |
*/
```
