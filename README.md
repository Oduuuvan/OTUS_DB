# Пояснительная записка
## _Тема – Школьное расписание_

- Пользователи 
    - users (пользователь)
    - teacher (учитель)
    - student (ученик)
- Реализация 
    - class (класс)
    - lesson (урок)
    - lesson_time (время уроков)
    - class_room (ученически кабинет)
    - school_subject (ученически предмет)
    - journal_entry (запись в журнале)
- Сеть
    - session (сессия)

---
### Домены
- integer_id = integer
- person_name = varchar(200)
- mail_str = varchar(45)

### Таблицы
- **users:**
_Таблица с общей для всех пользователей информацией_
    - users_id – суррогатный ключ (PK) (**integer_id**)
    - is_superuser – флаг суперпользователя (**boolean**)
    - name – имя (**person_name**)
    - surname – фамилия (**person_name**)
    - patronymic – отчество (**person_name**)
    - mail – электронная почта (**mail_str**)
    - username – логин пользователь (**varchar(20)**)
    - password – пароль пользователя (**varchar(20)**)
    - is_active – флаг активности (**boolean**)
    - last_login – последний логин пользователя (**timestamptz**)
    
- **teacher:**
_Таблица с доп информацией об учителе и обособляющая его как сущность_
    - teacher_id – суррогатный ключ (PK) (**integer_id**)
    - education – образование учителя (**text**)
    - work_experience – опыт работы учителя (**text**)
    - user_id – фнешний ключ на таблицу пользователя (FK) (**integer_id**)
    
- **student:**
_Таблица с доп информацией об ученике и обособляющая его как сущность_
    - student_id – суррогатный ключ (PK) (**integer_id**)
    - parent_mail – электронная почта родителя ребенка (**mail_str**)
    - additional_info – дополнительная информация об ученике (**text**)
    - user_id – фнешний ключ на таблицу пользователя (FK) (**integer_id**)
    - class_id – фнешний ключ на таблицу класса (FK) (**integer_id**)
    
- **class:**
_Таблица, в которой хранится информация о классе, как о группе учеников_
    - class_id – суррогатный ключ (PK) (**integer_id**)
    - start_year – год начала обучения (**date**)
    - end_year – год окончания обучения (**date**)
    - letter – буква класса (**varchar(1)**)
    - year_of_study - год обучения класса (**int2**)
    - teacher_id – классный руководитель, фнешний ключ на таблицу учителя (FK) (**integer_id**)
    
- **lesson:**
_Таблица, в которой хранится информация об одном конкретном уроке_
    - lesson_id – суррогатный ключ (PK) (**integer_id**)
    - homework – домашнее задание (**text**)
    - class_id – класс, которой должен прийти на этот урок, фнешний ключ на таблицу класса (FK) (**integer_id**)
    - teacher_id – учитель, который должен вести этот урок, фнешний ключ на таблицу учителя (FK) (**integer_id**)
    - lesson_time_id – время урока, фнешний ключ на таблицу времени урока (FK) (**integer_id**)
    - school_subject_id – предмет урока, фнешний ключ на таблицу предмета (FK) (**integer_id**)
    - class_room_id – кабинет, фнешний ключ на таблицу кабинета (FK) (**integer_id**)
    
- **lesson_time:**
_Таблица со временными интервалами уроков_
    - lesson_time_id – суррогатный ключ (PK) (**integer_id**)
    - start_time – время начала урока (**time**)
    - end_time – время окончания урока (**time**)
    
- **class_room:**
_Таблица с информацией о кабинете_
    - class_room_id – суррогатный ключ (PK) (**integer_id**)
    - number – номер кабинета (**varchar(10)**)
    - campus – корпус (**varchar(100)**)
    
- **school_subject:**
_Таблица с информацией об учиеническом предмете_
    - school_subject_id – суррогатный ключ (PK) (**integer_id**)
    - name – наименования предмета (**varchar(100)**)

- **journal_entry:**
_Таблица с записями в журнал для конкретного ученика и урока_
    - journal_entry_id – суррогатный ключ (PK) (**integer_id**)
    - mark_for_lesson – оценка за урок (**int2**)
    - mark_for_hw – оценка за дз (**int2**)
    - attendance – присутсвие (**boolean**)
    - student_id - ученик, фнешний ключ на таблицу ученика (FK) (**integer_id**)
    - lesson_id – урок, фнешний ключ на таблицу урока (FK) (**integer_id**)
    
- **session:**
_Таблица с информацией о сессии_
    - session_id – суррогатный ключ (PK) (**integer_id**)
    - session_data – данные сессии (**text**)
    - expire_time – время окончания сессии (**timestamptz**)
    
- **mtm_teacher_subject:**
_Таблица, реализуящая связь многиек ко многим для учителя и предмета_
    - teacher_subject_id – суррогатный ключ (PK) (**integer_id**)
    - teacher_id – фнешний ключ на таблицу учителя (FK) (**integer_id**)
    - school_subject_id – фнешний ключ на таблицу предмета (FK) (**integer_id**)

---
##### В данной базе можно вести электронный дневник ученика, составлять расписание, следить за успеваемостью
---
![school_db](https://github.com/Oduuuvan/OTUS_DB/raw/main/schemas/school_db.png)