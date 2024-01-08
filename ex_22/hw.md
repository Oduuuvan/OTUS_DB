- 1) Проанализировать типы данных в своем проекте, изменить при необходимости. В README указать что на что поменялось и почему.

Ко всем полям с типом integer и tinyint я добавил UNSIGNED, т.к. отрицательные значения мне нужны. Плюсом будет упрощение некоторых чеков.
- 2) Добавить тип JSON в структуру. Проанализировать какие данные могли бы там хранится. привести примеры SQL для добавления записей и выборки.

Изменил тип поля **additional_info** в таблице **student** c TEXT на JSON. Подразумевается, что в веб приложении будут несколько строк, которые ученик сможет заполнять. Например: спорт, хобби и т.д.
Изменение типа:
```
ALTER TABLE school.student 
MODIFY additional_info JSON;
```
Вставка JSON:
```
INSERT INTO school.student (additional_info)
        VALUES ('{"sport":["Футбол", "Настольный теннис"], "hobby":["Рисование"]}');
```
Запрос к полю с JSON:
```
SELECT 
	additional_info,
	JSON_EXTRACT(s.additional_info , "$.sport[0]")
FROM school.student s 
WHERE student_id = 1;
```