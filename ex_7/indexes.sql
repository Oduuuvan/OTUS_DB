-- Индекс для имени класса
CREATE INDEX IF NOT EXISTS idx_class_name ON school."class" (year_of_study, letter) TABLESPACE indexspace;

-- Индекс для ФИО
CREATE INDEX IF NOT EXISTS idx_fio ON school.users ("name", surname, patronymic) TABLESPACE indexspace;

-- Индексы на поля внешних ключей
CREATE INDEX IF NOT EXISTS idx_fk_teacher_uesrs ON school.teacher (user_id) TABLESPACE indexspace;
CREATE INDEX IF NOT EXISTS idx_fk_class_teacher ON school."class" (teacher_id) TABLESPACE indexspace;
CREATE INDEX IF NOT EXISTS idx_fk_student_uesrs ON school.student (user_id) TABLESPACE indexspace;
CREATE INDEX IF NOT EXISTS idx_fk_student_class ON school.student (class_id) TABLESPACE indexspace;
CREATE INDEX IF NOT EXISTS idx_fk_lesson_class ON school.lesson (class_id) TABLESPACE indexspace;
CREATE INDEX IF NOT EXISTS idx_fk_lesson_teacher ON school.lesson (teacher_id) TABLESPACE indexspace;
CREATE INDEX IF NOT EXISTS idx_fk_lesson_lesson_time ON school.lesson (lesson_time_id) TABLESPACE indexspace;
CREATE INDEX IF NOT EXISTS idx_fk_lesson_school_subject ON school.lesson (school_subject_id) TABLESPACE indexspace;
CREATE INDEX IF NOT EXISTS idx_fk_lesson_class_room ON school.lesson (class_room_id) TABLESPACE indexspace;
CREATE INDEX IF NOT EXISTS idx_fk_journal_entry_student ON school.journal_entry (student_id) TABLESPACE indexspace;
CREATE INDEX IF NOT EXISTS idx_fk_journal_entry_lesson ON school.journal_entry (lesson_id) TABLESPACE indexspace;
CREATE INDEX IF NOT EXISTS idx_fk_mtm_teacher_subject_teacher ON school.mtm_teacher_subject (teacher_id) TABLESPACE indexspace;
CREATE INDEX IF NOT EXISTS idx_fk_mtm_teacher_subject_school_subject ON school.mtm_teacher_subject (school_subject_id) TABLESPACE indexspace;

-- Число класса должно быть в диапозоне
ALTER TABLE school."class" ADD CONSTRAINT check_year_of_study CHECK (year_of_study > 0 and year_of_study < 12);

-- Цифра оценки должна быть в диапозоне
ALTER TABLE school.journal_entry ADD CONSTRAINT check_mark_for_lesson CHECK (mark_for_lesson > 1 and mark_for_lesson < 6);
ALTER TABLE school.journal_entry ADD CONSTRAINT check_mark_for_hw CHECK (mark_for_hw > 1 and mark_for_hw < 6);

-- Меил и логин должны быть уникальными
ALTER TABLE school.users ADD CONSTRAINT u_username UNIQUE (username);
ALTER TABLE school.users ADD CONSTRAINT u_mail UNIQUE (mail);
