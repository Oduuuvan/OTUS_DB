CREATE database school;
USE school;


CREATE TABLE IF NOT EXISTS school.users 
(
	users_id integer AUTO_INCREMENT PRIMARY KEY,
	is_superuser boolean,
	name varchar(200),
	surname varchar(200),
	patronymic varchar(200),
	mail varchar(45),
	username varchar(20),
	password varchar(20),
	is_active boolean,
	last_login timestamp
) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS school.teacher 
(
	teacher_id integer AUTO_INCREMENT PRIMARY KEY,
	education text,
	work_experience text,
	user_id integer,
	FOREIGN KEY (user_id) REFERENCES school.users (users_id)
) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS school.class 
(
	class_id integer AUTO_INCREMENT PRIMARY KEY,
	start_year date,
	end_year date,
	letter varchar(1),
	year_of_study tinyint,
	teacher_id integer,
	FOREIGN KEY (teacher_id) REFERENCES school.teacher (teacher_id)
) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS school.student 
(
	student_id integer AUTO_INCREMENT PRIMARY KEY,
	parent_mail varchar(45),
	additional_info text,
	user_id integer,
	FOREIGN KEY (user_id) REFERENCES school.users (users_id),
	class_id integer,
	FOREIGN KEY (class_id) REFERENCES school.class (class_id)
) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS school.lesson_time 
(
	lesson_time_id integer AUTO_INCREMENT PRIMARY KEY,
	start_time time,
	end_time time
) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS school.class_room 
(
	class_room_id integer AUTO_INCREMENT PRIMARY KEY,
	number varchar(10),
	campus varchar(100)
) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS school.school_subject 
(
	school_subject_id integer AUTO_INCREMENT PRIMARY KEY,
	name varchar(100)
) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS school.lesson 
(
	lesson_id integer AUTO_INCREMENT PRIMARY KEY,
	homework text,
	lesson_date date,
	class_id integer,
	FOREIGN KEY (class_id) REFERENCES school.class (class_id),
	teacher_id integer,
	FOREIGN KEY (teacher_id) REFERENCES school.teacher (teacher_id),
	lesson_time_id integer,
	FOREIGN KEY (lesson_time_id) REFERENCES school.lesson_time (lesson_time_id),
	school_subject_id integer,
	FOREIGN KEY (school_subject_id) REFERENCES school.school_subject (school_subject_id),
	class_room_id integer,
	FOREIGN KEY (class_room_id) REFERENCES school.class_room (class_room_id)
) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS school.journal_entry 
(
	journal_entry_id integer AUTO_INCREMENT PRIMARY KEY,
	mark_for_lesson int2,
	mark_for_hw int2,
	attendance boolean,
	student_id integer,
	FOREIGN KEY (student_id) REFERENCES school.student (student_id),
	lesson_id integer,
	FOREIGN KEY (lesson_id) REFERENCES school.lesson (lesson_id)
) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS school.mtm_teacher_subject 
(
	teacher_subject_id integer AUTO_INCREMENT PRIMARY KEY,
	teacher_id integer,
	FOREIGN KEY (teacher_id) REFERENCES school.teacher (teacher_id),
	school_subject_id integer,
	FOREIGN KEY (school_subject_id) REFERENCES school.school_subject (school_subject_id)
) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS school.session 
(
	session_id integer AUTO_INCREMENT PRIMARY KEY,
	session_data text,
	expire_time timestamp
) ENGINE=INNODB;


CREATE INDEX idx_class_name ON school.class (year_of_study, letter);
CREATE INDEX idx_fio ON school.users (name, surname, patronymic);
CREATE INDEX idx_fk_teacher_uesrs ON school.teacher (user_id);
CREATE INDEX idx_fk_class_teacher ON school.class (teacher_id);
CREATE INDEX idx_fk_student_uesrs ON school.student (user_id);
CREATE INDEX idx_fk_student_class ON school.student (class_id);
CREATE INDEX idx_fk_lesson_class ON school.lesson (class_id);
CREATE INDEX idx_fk_lesson_teacher ON school.lesson (teacher_id);
CREATE INDEX idx_fk_lesson_lesson_time ON school.lesson (lesson_time_id);
CREATE INDEX idx_fk_lesson_school_subject ON school.lesson (school_subject_id);
CREATE INDEX idx_fk_lesson_class_room ON school.lesson (class_room_id);
CREATE INDEX idx_fk_journal_entry_student ON school.journal_entry (student_id);
CREATE INDEX idx_fk_journal_entry_lesson ON school.journal_entry (lesson_id);
CREATE INDEX idx_fk_mtm_teacher_subject_teacher ON school.mtm_teacher_subject (teacher_id);
CREATE INDEX idx_fk_mtm_teacher_subject_school_subject ON school.mtm_teacher_subject (school_subject_id);
