-- 1) Напишите запрос по своей базе с регулярным выражением, добавьте пояснение, что вы хотите найти.
-- Поиск женщин в таблице пользователй по окончанию отчества
SELECT * FROM users u WHERE u.patronymic SIMILAR TO '%вна';


-- 2) Напишите запрос по своей базе с использованием LEFT JOIN и INNER JOIN, как порядок соединений в FROM влияет на результат? Почему?
-- Вывести всех пользователей с пометкой у тех, кто является учеником
SELECT 
	u."name",
	u.surname,
	u.patronymic,
	s.student_id
FROM users u 
LEFT JOIN student s ON s.user_id = u.users_id;

-- Вывести всех учеников с названием их класса
SELECT 
	u."name",
	u.surname,
	u.patronymic,
	s.student_id,
	c.year_of_study,
	c.letter 
FROM users u 
INNER JOIN student s ON s.user_id = u.users_id
INNER JOIN "class" c ON s.class_id = c.class_id;

-- При внутреннем объединении (INNER) порядок не важен, когда же объединение внешнее (LEFT или RIGHT), то порядок важен, 
-- будут включены все строки из таблицы на указанной стороне, а из таблицы на другой стороне будут включены только строки, подходящие по критерию в ON.


-- 3) Напишите запрос на добавление данных с выводом информации о добавленных строках.
INSERT INTO school_subject(name) VALUES('классный час') RETURNING school_subject_id, name;


-- 4) Напишите запрос с обновлением данные используя UPDATE FROM.
-- Сменить предмет урока у запсис с lesson_id = 6 на классный час
UPDATE lesson l
SET 
	school_subject_id = ss.school_subject_id
FROM (
	SELECT school_subject_id 
	FROM school_subject 
	WHERE name = 'классный час'
	) AS ss
WHERE lesson_id = 6;


-- 5) Напишите запрос для удаления данных с оператором DELETE используя join с другой таблицей с помощью using.
-- Удалить запись об уроке, где предметом урока является классный час
DELETE FROM lesson l
USING school_subject s
WHERE l.school_subject_id = s.school_subject_id 
	AND s.name = 'классный час';
	
ROLLBACK;


-- *) Приведите пример использования утилиты COPY
-- Поместить результат запроса в файл
COPY (
	SELECT 
		u."name",
		u.surname,
		u.patronymic,
		s.student_id,
		c.year_of_study,
		c.letter 
	FROM users u 
	INNER JOIN student s ON s.user_id = u.users_id
	INNER JOIN "class" c ON s.class_id = c.class_id
	) 
TO '/tmp/students.copy';

-- Также, приходилось пользоваться расширением file_fdw для создания внешних таблиц на основе csv файлов
-- В основе file_fdw лежат запросы c COPY
