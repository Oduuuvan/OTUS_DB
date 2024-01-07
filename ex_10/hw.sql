-- 1) Создать индекс к какой-либо из таблиц вашей БД.
CREATE INDEX IF NOT EXISTS idx_vacancies_name ON habr.vacancies ("name");


-- 2) Прислать текстом результат команды explain, в которой используется данный индекс.
EXPLAIN 
SELECT "name" FROM habr.vacancies v WHERE "name" = 'Senior Data Scientist (проект Customer Value Managnent)';
-- До создания индекса:
-- Seq Scan on vacancies v  (cost=0.00..495.06 rows=1 width=44)
--   Filter: ((name)::text = 'Senior Data Scientist (проект Customer Value Managnent)'::text)

-- После:
-- Index Only Scan using idx_vacancies_name on vacancies v  (cost=0.29..8.30 rows=1 width=44)
--   Index Cond: (name = 'Senior Data Scientist (проект Customer Value Managnent)'::text)


-- 3) Реализовать индекс для полнотекстового поиска.
-- При попытке создать индекс, выдавал ошибку. Для устранения, было необходимо подключить расширение btree_gin.
CREATE EXTENSION btree_gin
CREATE INDEX IF NOT EXISTS idx_vacancies_name ON habr.vacancies  USING GIN (to_tsvector('russian', "name"));

EXPLAIN 
SELECT "name"
FROM habr.vacancies
WHERE to_tsvector('russian', "name") @@ to_tsquery('russian', 'разработчик');
-- До создания индекса:
-- Seq Scan on vacancies  (cost=0.00..3276.31 rows=56 width=44)
--   Filter: (to_tsvector('russian'::regconfig, (name)::text) @@ '''разработчик'''::tsquery)

-- После:
-- Bitmap Heap Scan on vacancies  (cost=12.43..175.51 rows=56 width=44)
--   Recheck Cond: (to_tsvector('russian'::regconfig, (name)::text) @@ '''разработчик'''::tsquery)
--   ->  Bitmap Index Scan on idx_vacancies_name  (cost=0.00..12.42 rows=56 width=0)
--         Index Cond: (to_tsvector('russian'::regconfig, (name)::text) @@ '''разработчик'''::tsquery)


-- 4) Реализовать индекс на часть таблицы или индекс на поле с функцией.
-- Изначально пытался конвертировать строку с датой при помощи функции date(), но посгрес выдавал ошибку, 
-- за использование IMMUTABLE функции в индексе. Оказалось, что можно просто опустить эту функцию.
CREATE INDEX idx_part_pub_date ON habr.vacancies (pub_date) WHERE pub_date >= '2023-01-01' AND pub_date < '2023-02-01';

EXPLAIN 
SELECT * FROM habr.vacancies v WHERE pub_date = '2023-01-10';
-- До создания индекса, запрос использовал обычный btree индекс по полю pub_date:
-- Index Scan using idx_habrvac_pub_date on vacancies v  (cost=0.29..8.30 rows=1 width=200)
--   Index Cond: (pub_date = '2023-01-10 00:00:00+03'::timestamp with time zone)

-- После:
-- Index Scan using idx_part_pub_date on vacancies v  (cost=0.28..8.30 rows=1 width=200)
--   Index Cond: (pub_date = '2023-01-10 00:00:00+03'::timestamp with time zone)


-- 5) Создать индекс на несколько полей.
CREATE INDEX idx_name_and_employer_id ON habr.vacancies ("name", employer_id);

EXPLAIN
SELECT * FROM habr.vacancies v WHERE employer_id = 186 AND name = 'Бизнес-аналитик';
-- До создания индекса:
-- Seq Scan on vacancies v  (cost=0.00..522.88 rows=1 width=200)
--   Filter: ((employer_id = 186) AND ((name)::text = 'Бизнес-аналитик'::text))

-- После:
-- Index Scan using idx_name_and_employer_id on vacancies v  (cost=0.41..8.43 rows=1 width=200)
--   Index Cond: (((name)::text = 'Бизнес-аналитик'::text) AND (employer_id = 186))