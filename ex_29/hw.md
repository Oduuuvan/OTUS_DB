### Создать пользователей client, manager.
```sql
-- клиент:
CREATE USER 'client'@'localhost'  IDENTIFIED BY 'pass';
-- менеджер:
CREATE USER 'manager'@'localhost' IDENTIFIED BY 'pass';
```
### Создать процедуру выборки товаров с использованием различных фильтров: категория, цена, производитель, различные дополнительные параметры. Также в качестве параметров передавать по какому полю сортировать выборку, и параметры постраничной выдачи.

```sql
-- Создание процедуры
CREATE PROCEDURE get_product(
	IN p_product_name VARCHAR(100),
	IN p_category_name VARCHAR(100),
	IN p_price VARCHAR(10),
	IN p_quantity VARCHAR(10),
	IN p_sort_column VARCHAR(50),
	IN p_offset_count INTEGER,
  	IN p_limit_count INTEGER)
BEGIN
	-- Начальная выборка
    SET @sql_select = 
    	'SELECT
			p.product_name,
			p.price,
			p.quantity,
			c.category_name
		FROM product p 
		JOIN category c ON c.category_id = p.category_id';
	
	-- Фильтрация
	SET @sql_where = '';

    IF p_product_name != '' 
    THEN
		SET @sql_where = CONCAT(@sql_where, ' WHERE UPPER(product_name) LIKE UPPER(\'%', p_product_name, '%\')');
	END IF;
	
	IF p_category_name != '' 
	THEN
		IF @sql_where = ''
		THEN 
			SET @sql_where = CONCAT(@sql_where, ' WHERE UPPER(category_name) LIKE UPPER(\'%', p_category_name, '%\')');
		ELSE 
			SET @sql_where = CONCAT(@sql_where, ' AND UPPER(category_name) LIKE UPPER(\'%', p_category_name, '%\')');
		END IF;
	END IF;
	
	IF p_price != ''
	THEN 
		IF @sql_where = ''
		THEN 
			SET @sql_where = CONCAT(@sql_where, ' WHERE price ', p_price);
		ELSE 
			SET @sql_where = CONCAT(@sql_where, ' AND price ', p_price);
		END IF;
	END IF;
	
	IF p_quantity != ''
	THEN 
		IF @sql_where = ''
		THEN 
			SET @sql_where = CONCAT(@sql_where, ' WHERE quantity ', p_quantity);
		ELSE 
			SET @sql_where = CONCAT(@sql_where, ' AND quantity ', p_quantity);
		END IF;
	END IF;

    -- Сортировка
    SET @sql_order = CONCAT(' ORDER BY ', p_sort_column);
   
    -- Пагинация
    SET @sql_limit = CONCAT(' LIMIT ', p_limit_count, 'OFFSET ', p_offset_count);
   
   	-- Склеиваем все сместе
    SET @sql_select = CONCAT(@sql_select, @sql_where, @sql_order, @sql_limit);

    PREPARE stmp FROM @sql_select;
    EXECUTE stmp;
END;  

-- Вызов процедуры
CALL get_product('молоко', '', '>15', '', 'quantity', 4, 3);
```
### Дать права да запуск процедуры пользователю client.

```sql
GRANT privileges ON get_product TO client;
```
### Создать процедуру get_orders - которая позволяет просматривать отчет по продажам за определенный период (час, день, неделя) с различными уровнями группировки (по товару, по категории, по производителю).

```sql
CREATE PROCEDURE get_orders (
    IN p_start_period datetime,
    IN p_end_period datetime,
    IN p_column_group VARCHAR(50))
BEGIN
    SET @sql_select = 
    CONCAT('SELECT ', p_column_group,
    ', sum(p.price) as sum_price from product p');

    SET @sql_where = CONCAT(' WHERE order_date BETWEEN \'', p_start_period, ''\ AND ', p_end_period, '\'');

    SET @sql_group = CONCAT(' GROUP BY ', p_column_group);

    SET @sql_query = CONCAT(@sql_select, @sql_where, @sql_group);

    PREPARE stmp FROM @sql_query;
    EXECUTE stmp;
END;

-- запуск процедуры:
CALL get_orders('2024-01-10:00-00-00', '2024-02-01:00-00-00', 'product_name');
```

### Права дать пользователю manager.

```sql
GRANT privileges ON get_orders TO manager;
```