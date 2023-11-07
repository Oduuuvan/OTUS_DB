CREATE TABLESPACE indexspace LOCATION '/data/indexes';

CREATE SCHEMA IF NOT EXISTS school;


SET search_path TO school,public;


CREATE DOMAIN school.integer_id AS integer;
CREATE DOMAIN school.person_name AS varchar(200);
CREATE DOMAIN school.mail_str AS varchar(45);


CREATE TABLE IF NOT EXISTS school.users 
(
	users_id integer PRIMARY KEY generated always as IDENTITY,
	is_superuser boolean,
	"name" person_name,
	surname person_name,
	patronymic person_name,
	mail mail_str,
	username varchar(20),
	"password" varchar(20),
	is_active boolean,
	last_login timestamptz
);


CREATE TABLE IF NOT EXISTS school.teacher 
(
	teacher_id integer PRIMARY KEY generated always as IDENTITY,
	education text,
	work_experience text,
	user_id integer_id REFERENCES school.users (users_id)
);


CREATE TABLE IF NOT EXISTS school.class 
(
	class_id integer PRIMARY KEY generated always as IDENTITY,
	start_year date,
	end_year date,
	letter varchar(1),
	year_of_study int2,
	teacher_id integer_id REFERENCES school.teacher (teacher_id)
);


CREATE TABLE IF NOT EXISTS school.student 
(
	student_id integer PRIMARY KEY generated always as IDENTITY,
	parent_mail mail_str,
	additional_info text,
	user_id integer_id REFERENCES school.users (users_id),
	class_id integer_id REFERENCES school.class (class_id)
);


CREATE TABLE IF NOT EXISTS school.lesson_time 
(
	lesson_time_id integer PRIMARY KEY generated always as IDENTITY,
	start_time time,
	end_time time
);


CREATE TABLE IF NOT EXISTS school.class_room 
(
	class_room_id integer PRIMARY KEY generated always as IDENTITY,
	"number" varchar(10),
	campus varchar(100)
);


CREATE TABLE IF NOT EXISTS school.school_subject 
(
	school_subject_id integer PRIMARY KEY generated always as IDENTITY,
	name varchar(100)
);


CREATE TABLE IF NOT EXISTS school.lesson 
(
	lesson_id integer PRIMARY KEY generated always as IDENTITY,
	homework text,
	class_id integer_id REFERENCES school.class (class_id),
	teacher_id integer_id REFERENCES school.teacher (teacher_id),
	lesson_time_id integer_id REFERENCES school.lesson_time (lesson_time_id),
	school_subject_id integer_id REFERENCES school.school_subject (school_subject_id),
	class_room_id integer_id REFERENCES school.class_room (class_room_id)
);


CREATE TABLE IF NOT EXISTS school.journal_entry 
(
	journal_entry_id integer PRIMARY KEY generated always as IDENTITY,
	mark_for_lesson int2,
	mark_for_hw int2,
	attendance boolean,
	student_id integer_id REFERENCES school.student (student_id),
	lesson_id integer_id REFERENCES school.lesson (lesson_id)
);


CREATE TABLE IF NOT EXISTS school.mtm_teacher_subject 
(
	teacher_subject_id integer PRIMARY KEY generated always as IDENTITY,
	teacher_id integer_id REFERENCES school.teacher (teacher_id),
	school_subject_id integer_id REFERENCES school.school_subject (school_subject_id)
);


CREATE TABLE IF NOT EXISTS school.session 
(
	session_id integer PRIMARY KEY generated always as IDENTITY,
	session_data text,
	expire_time timestamptz
);