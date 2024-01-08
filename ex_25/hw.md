### Описать пример транзакции из своего проекта с изменением данных в нескольких таблицах. Реализовать в виде хранимой процедуры.
```
-- Процедура для перевода пользователя в активное состояние
CREATE PROCEDURE set_user_is_active(
    in p_user_id  integer, 
    IN p_session_data text
)
BEGIN
	-- Проставим флаг активности у пользователя
	UPDATE school.users
	SET is_active = TRUE,
		last_login = now()
	WHERE users_id = p_user_id;
	
	-- Зададим время жизни сессии
	INSERT INTO school.`session` (session_data, expire_time) VALUES (p_session_data, DATE_ADD(NOW(), INTERVAL 1 HOUR));
	COMMIT;
END;

-- Вызов функции
CALL set_user_is_active(1, 'some_data');
```

### Загрузить данные из приложенных в материалах csv. Реализовать следующими путями: LOAD DATA
Создал таблицу
```
CREATE TABLE `Apparel` (
`handle` varchar(30) NOT NULL,
`title` varchar(25) DEFAULT NULL,
`body` text,
`vendor` varchar(30) DEFAULT NULL,
`type` varchar(15) DEFAULT NULL,
`tags` varchar(15) DEFAULT NULL,
`published` varchar(10) DEFAULT NULL,
`option1_name` varchar(10) DEFAULT NULL,
`option1_value` varchar(25) DEFAULT NULL,
`option2_name` varchar(10) DEFAULT NULL,
`option2_value` varchar(5) DEFAULT NULL,
`option3_name` varchar(10) DEFAULT NULL,
`option3_value` varchar(10) DEFAULT NULL,
`variant_sku` varchar(15) DEFAULT NULL,
`variant_grams` int DEFAULT NULL,
`variant_inventory_tracker` varchar(10) DEFAULT NULL,
`variant_inventory_qty` int DEFAULT NULL,
`variant_inventory_policy` varchar(15) DEFAULT NULL,
`variant_fulfillment_service` varchar(6) DEFAULT NULL,
`variant_price` decimal(19,2) DEFAULT NULL,
`variant_compare_at_price` decimal(19,2) DEFAULT NULL,
`variant_requires_shipping` varchar(5) DEFAULT NULL,
`variant_taxable` varchar(5) DEFAULT NULL,
`variant_barcode` varchar(50) DEFAULT NULL,
`image_src` varchar(300) DEFAULT NULL,
`image_alt_text` varchar(50) DEFAULT NULL,
`gift_card` varchar(5) DEFAULT NULL,
`seo_title` varchar(10) DEFAULT NULL,
`seo_description` varchar(300) DEFAULT NULL,
`google_shopping_google_product_category` text,
`google_shopping_Gender` text,
`google_shopping_age_group` text,
`google_shopping_mpn` text,
`google_shopping_adwords_grouping` text,
`google_shopping_adwords_lables` text,
`google_shopping_condition` text,
`google_shopping_custom_product` text,
`google_shopping_custom_label_0` text,
`google_shopping_custom_label_1` text,
`google_shopping_custom_label_2` text,
`google_shopping_custom_label_3` text,
`google_shopping_custom_label_4` text,
`variant_image` varchar(200) DEFAULT NULL,
`variant_weight_unit` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
Скопировал файл в докер
```docker cp Apparel.csv otus-mysql-docker-otusdb-1:/var/tmp```
Подключился к базе с флагом --local-infile
```mysql -h localhost -u root -p --local-infile school```
Выполнил загрузку
```
mysql> LOAD DATA LOCAL INFILE '/var/tmp/Apparel.csv'
    -> INTO TABLE Apparel
    -> FIELDS TERMINATED BY ','
    -> ENCLOSED BY '"'
    -> LINES TERMINATED BY '\n'
    -> IGNORE 1 ROWS;
Query OK, 104 rows affected, 154 warnings (0.02 sec)
Records: 104  Deleted: 0  Skipped: 0  Warnings: 154
```
Проверка наличия данных 
```
mysql> select count(*) from Apparel;
+----------+
| count(*) |
+----------+
|      104 |
+----------+
1 row in set (0.00 sec)
```

