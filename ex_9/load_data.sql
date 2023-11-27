SET search_path TO school,public;

INSERT INTO users(is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (True, 'Сатилин', 'Владислав', 'Александрович', 'email@exaple1.com', 'vsatilin', '123', False, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));
INSERT INTO users(is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (False, 'Рыжкова', 'Юлия', 'Олеговна', 'email@exaple2.com', 'jrijkova', '123', False, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));
INSERT INTO users(is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (False, 'Иванов', 'Олег', 'Игоревич', 'email@exaple3.com', 'oivanov', '123', False, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));
INSERT INTO users(is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (False, 'Баров', 'Александр', 'Конастантинович', 'email@exaple4.com', 'abarov', '123', False, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));
INSERT INTO users(is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (False, 'Гусева', 'Алина', 'Дмитриевна', 'email@exaple5.com', 'aguseva', '123', False, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));
INSERT INTO users(is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (False, 'Чикова', 'Валерия', 'Викторовна', 'email@exaple6.com', 'vchikova', '123', False, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));
INSERT INTO users(is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (False, 'Ярмолина', 'Вероника', 'Сергеевна', 'email@exaple7.com', 'vyarmolina', '123', False, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));
INSERT INTO users(is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (False, 'Гасанова', 'Карина', 'Владимировна', 'email@exaple8.com', 'kgasanova', '123', False, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));
INSERT INTO users(is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (False, 'Ковач', 'Анна', 'Александровна', 'email@exaple9.com', 'akovach', '123', False, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));
INSERT INTO users(is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (False, 'Ударцев', 'Максим', 'Витальевич', 'email@exaple10.com', 'mudarcev', '123', False, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));
INSERT INTO users(is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (False, 'Козлов', 'Денис', 'Артемович', 'email@exaple11.com', 'dkozlov', '123', False, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));
INSERT INTO users(is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (False, 'Гаянова', 'Любовь', 'Сергеевна', 'email@exaple12.com', 'lgayanova', '123', False, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));
INSERT INTO users(is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (False, 'Малова', 'Анастасия', 'Петровна', 'email@exaple13.com', 'amalova', '123', False, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));
INSERT INTO users(is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (False, 'Свиридова', 'Юлия', 'Александровна', 'email@exaple14.com', 'jsviridova', '123', False, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));        
INSERT INTO users(is_superuser, surname, name, patronymic, mail, username, password, is_active, last_login)
        VALUES (False, 'Орлова', 'Анна', 'Петровна', 'email@exaple15.com', 'aorlova', '123', False, TO_DATE('22.10.2021 12:00:00', 'dd.mm.yyyy hh24:mi:ss'));
        
INSERT INTO class_room(number, campus) VALUES (1, 'ГУК');
INSERT INTO class_room(number, campus) VALUES (2, 'ГУК');
INSERT INTO class_room(number, campus) VALUES (3, 'ГУК');
INSERT INTO class_room(number, campus) VALUES (4, 'ГУК');
INSERT INTO class_room(number, campus) VALUES (5, 'ГУК');
INSERT INTO class_room(number, campus) VALUES (1, 'Высотка');
INSERT INTO class_room(number, campus) VALUES (2, 'Высотка');
INSERT INTO class_room(number, campus) VALUES (3, 'Высотка');
INSERT INTO class_room(number, campus) VALUES (1, 'А');
INSERT INTO class_room(number, campus) VALUES (1, 'Б');


INSERT INTO teacher(work_experience, education, user_id) 
    VALUES('5 лет стажа', 'Высшее пдагогическое (ВГСПУ)', 1);
INSERT INTO teacher(work_experience, education, user_id) 
    VALUES('3 года стажа', 'Высшее пдагогическое (ВГСПУ)', 2);
INSERT INTO teacher(work_experience, education, user_id) 
    VALUES('6 лет стажа', 'Среднее специальное (ВГСПУ)', 3);
INSERT INTO teacher(work_experience, education, user_id) 
    VALUES('6 лет стажа', 'Среднее специальное (ВГСПУ)', 4);
INSERT INTO teacher(work_experience, education, user_id) 
    VALUES('15 лет стажа', 'Высшее пдагогическое (ВГСПУ)', 5);
   
INSERT INTO class(start_year, end_year, letter, year_of_study, teacher_id) 
    VALUES(TO_DATE('2011', 'yyyy'), TO_DATE('2022', 'yyyy'), 'А', 10, 1);
INSERT INTO class(start_year, end_year, letter, year_of_study, teacher_id) 
    VALUES(TO_DATE('2011', 'yyyy'), TO_DATE('2022', 'yyyy'), 'Б', 10, 2);
INSERT INTO class(start_year, end_year, letter, year_of_study, teacher_id) 
    VALUES(TO_DATE('2015', 'yyyy'), TO_DATE('2026', 'yyyy'), 'А', 6, 3);
   
INSERT INTO student(parent_mail, additional_info, user_id, class_id) 
    VALUES('parent_mail@example.com', 'Люблю играть в футбол', 6, 2);
INSERT INTO student(parent_mail, user_id, class_id) 
    VALUES('parent_mail@example.com', 7, 2);    
INSERT INTO student(parent_mail, user_id, class_id) 
    VALUES('parent_mail@example.com', 8, 2);
INSERT INTO student(parent_mail, additional_info, user_id, class_id) 
    VALUES('parent_mail@example.com', 'Когда вырасту, стану программистом', 9, 2);
INSERT INTO student(parent_mail, user_id, class_id) 
    VALUES('parent_mail@example.com', 10, 2);
INSERT INTO student(parent_mail, user_id, class_id) 
    VALUES('parent_mail@example.com', 11, 2);    
INSERT INTO student(parent_mail, user_id, class_id) 
    VALUES('parent_mail@example.com', 12, 2);
INSERT INTO student(parent_mail, user_id, class_id) 
    VALUES('parent_mail@example.com', 13, 3);  
INSERT INTO student(parent_mail, user_id, class_id) 
    VALUES('parent_mail@example.com', 14, 3);    
INSERT INTO student(parent_mail, user_id, class_id) 
    VALUES('parent_mail@example.com', 15, 3);
   
INSERT INTO school_subject(name) VALUES('алгебра');
INSERT INTO school_subject(name) VALUES('геометрия');
INSERT INTO school_subject(name) VALUES('русский');
INSERT INTO school_subject(name) VALUES('история');
INSERT INTO school_subject(name) VALUES('обществознание');
INSERT INTO school_subject(name) VALUES('биология');
INSERT INTO school_subject(name) VALUES('химия');
INSERT INTO school_subject(name) VALUES('география');
INSERT INTO school_subject(name) VALUES('физическая культура');
INSERT INTO school_subject(name) VALUES('литература');

INSERT INTO mtm_teacher_subject(teacher_id, school_subject_id) VALUES(1, 1);
INSERT INTO mtm_teacher_subject(teacher_id, school_subject_id) VALUES(1, 2);
INSERT INTO mtm_teacher_subject(teacher_id, school_subject_id) VALUES(2, 3);
INSERT INTO mtm_teacher_subject(teacher_id, school_subject_id) VALUES(2, 10);
INSERT INTO mtm_teacher_subject(teacher_id, school_subject_id) VALUES(3, 4);
INSERT INTO mtm_teacher_subject(teacher_id, school_subject_id) VALUES(3, 5);
INSERT INTO mtm_teacher_subject(teacher_id, school_subject_id) VALUES(4, 6);
INSERT INTO mtm_teacher_subject(teacher_id, school_subject_id) VALUES(4, 7);
INSERT INTO mtm_teacher_subject(teacher_id, school_subject_id) VALUES(5, 8);
INSERT INTO mtm_teacher_subject(teacher_id, school_subject_id) VALUES(5, 9);

INSERT INTO lesson_time(start_time, end_time) 
    VALUES(TO_TIMESTAMP('8:30','hh24:mi'), TO_TIMESTAMP('9:10','hh24:mi'));
INSERT INTO lesson_time(start_time, end_time) 
    VALUES(TO_TIMESTAMP('9:20','hh24:mi'), TO_TIMESTAMP('10:00','hh24:mi'));
INSERT INTO lesson_time(start_time, end_time) 
    VALUES(TO_TIMESTAMP('10:20','hh24:mi'), TO_TIMESTAMP('11:00','hh24:mi'));
INSERT INTO lesson_time(start_time, end_time) 
    VALUES(TO_TIMESTAMP('11:20','hh24:mi'), TO_TIMESTAMP('12:00','hh24:mi'));
INSERT INTO lesson_time(start_time, end_time) 
    VALUES(TO_TIMESTAMP('12:10','hh24:mi'), TO_TIMESTAMP('12:50','hh24:mi'));
INSERT INTO lesson_time(start_time, end_time) 
    VALUES(TO_TIMESTAMP('13:00','hh24:mi'), TO_TIMESTAMP('13:40','hh24:mi'));
   
INSERT INTO lesson(homework, lesson_date, class_id, teacher_id, class_room_id, school_subject_id, lesson_time_id) 
    VALUES('№10', TO_DATE('25.10.21','dd.mm.yy'), 2, 1, 1, 1, 1);
INSERT INTO lesson(homework, lesson_date, class_id, teacher_id, class_room_id, school_subject_id, lesson_time_id) 
    VALUES('Задача с доски', TO_DATE('25.10.21','dd.mm.yy'), 2, 1, 1, 2, 2);
INSERT INTO lesson(homework, lesson_date, class_id, teacher_id, class_room_id, school_subject_id, lesson_time_id) 
    VALUES('Упр.6', TO_DATE('25.10.21','dd.mm.yy'), 2, 2, 2, 3, 3);
INSERT INTO lesson(lesson_date, class_id, teacher_id, class_room_id, school_subject_id, lesson_time_id) 
    VALUES(TO_DATE('25.10.21','dd.mm.yy'), 2, 3, 4, 4, 4);    
INSERT INTO lesson(lesson_date, class_id, teacher_id, class_room_id, school_subject_id, lesson_time_id) 
    VALUES(TO_DATE('25.10.21','dd.mm.yy'), 2, 4, 3, 7, 5);
INSERT INTO lesson(lesson_date, class_id, teacher_id, class_room_id, school_subject_id, lesson_time_id) 
    VALUES(TO_DATE('25.10.21','dd.mm.yy'), 2, 5, 9, 9, 6);
 
INSERT INTO journal_entry(mark_for_lesson, mark_for_hw, attendance, student_id, lesson_id) 
    VALUES(4, 5, True, 1, 1);
INSERT INTO journal_entry(mark_for_lesson, mark_for_hw, attendance, student_id, lesson_id) 
    VALUES(3, 3, True, 2, 1);
INSERT INTO journal_entry(mark_for_hw, attendance, student_id, lesson_id) 
    VALUES(5, True, 3, 1);
INSERT INTO journal_entry(mark_for_hw, attendance, student_id, lesson_id) 
    VALUES(2, True, 4, 1);
INSERT INTO journal_entry(attendance, student_id, lesson_id) 
    VALUES(False, 5, 1);
INSERT INTO journal_entry(mark_for_hw, attendance, student_id, lesson_id) 
    VALUES(5, True, 6, 1);
INSERT INTO journal_entry(mark_for_lesson, mark_for_hw, attendance, student_id, lesson_id) 
    VALUES(5, 5, True, 7, 2);
INSERT INTO journal_entry(mark_for_lesson, mark_for_hw, attendance, student_id, lesson_id) 
    VALUES(5, 3, True, 1, 2);
INSERT INTO journal_entry(attendance, student_id, lesson_id) 
    VALUES(False, 2, 2);
INSERT INTO journal_entry(attendance, student_id, lesson_id) 
    VALUES(False, 3, 2);

INSERT INTO session(session_data, expire_time) 
    VALUES('1234567890', TO_DATE('24.10.2021 16:00:00','dd.mm.yyyy hh24:mi:ss'));   
INSERT INTO session(session_data, expire_time) 
    VALUES('1234567890', TO_DATE('24.10.2021 16:00:00','dd.mm.yyyy hh24:mi:ss'));
INSERT INTO session(session_data, expire_time) 
    VALUES('1234567890', TO_DATE('24.10.2021 16:00:00','dd.mm.yyyy hh24:mi:ss'));
INSERT INTO session(session_data, expire_time) 
    VALUES('1234567890', TO_DATE('24.10.2021 16:00:00','dd.mm.yyyy hh24:mi:ss'));
INSERT INTO session(session_data, expire_time) 
    VALUES('1234567890', TO_DATE('24.10.2021 16:00:00','dd.mm.yyyy hh24:mi:ss'));