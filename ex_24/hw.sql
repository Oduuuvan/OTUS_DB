-- 1) Напишите запрос по своей базе с inner join.
-- Вывести всех учеников с названием их класса
SELECT 
	u.name,
	u.surname,
	u.patronymic,
	s.student_id,
	c.year_of_study,
	c.letter 
FROM users u 
INNER JOIN student s ON s.user_id = u.users_id
INNER JOIN class c ON s.class_id = c.class_id;


-- 2) Напишите запрос по своей базе с left join
-- Вывести всех пользователей с пометкой у тех, кто является учеником
SELECT 
	u.name,
	u.surname,
	u.patronymic,
	s.student_id
FROM users u 
LEFT JOIN student s ON s.user_id = u.users_id;


-- 3) Напишите 5 запросов с WHERE с использованием разных операторов, опишите для чего вам в проекте нужна такая выборка данных.

-- Узнать логин пользоавтеля по фамилии
SELECT username 
FROM users u 
WHERE upper(surname) like 'САТИЛИН';

-- Узнать сколько уроков начнется в период времени
SELECT lesson_time_id, start_time 
FROM lesson_time lt 
WHERE start_time BETWEEN TIME_FORMAT('8:30','%H:%i') AND TIME_FORMAT('12:00','%H:%i')

-- Вывести учеников только с хорошими отметками за урок
SELECT 
	u.surname,
	u.name,
	u.patronymic,
	je.mark_for_lesson
FROM journal_entry je 
JOIN student s ON s.student_id = je.student_id
JOIN users u ON u.users_id = s.user_id 
WHERE je.mark_for_lesson > 3 

-- Вывести учеников, у котрых заполнена доп. информация
SELECT 
	* 
FROM student s 
JOIN users u ON u.users_id = s.user_id
WHERE additional_info IS NOT NULL;

-- Вывести учеников только с отметками 2 и 5 за урок
SELECT 
	u.surname,
	u.name,
	u.patronymic,
	je.mark_for_hw
FROM journal_entry je 
JOIN student s ON s.student_id = je.student_id
JOIN users u ON u.users_id = s.user_id 
WHERE je.mark_for_hw IN (2,5)