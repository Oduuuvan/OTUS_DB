### Возьмите сложную выборку из предыдущих ДЗ с несколькими join и подзапросами. Постройте EXPLAIN в 3 формата.
```sql
-- Выборка
WITH cte AS (
	SELECT 
		l.lesson_id, 
		je.mark_for_lesson,
		je.mark_for_hw,
		u.users_id,
		(SELECT CONCAT(u2.name, ' ', u2.surname, ' ', u2.patronymic) FROM users u2 WHERE u2.users_id = s.user_id) AS FIO,
		c.year_of_study,
		c.letter 
	FROM lesson l 
	LEFT JOIN journal_entry je ON je.lesson_id = l.lesson_id 
	LEFT JOIN student s ON je.student_id = s.student_id
	LEFT JOIN users u ON s.user_id = u.users_id
	LEFT JOIN class c ON s.class_id = c.class_id 
	LEFT JOIN lesson_time lt ON l.lesson_time_id = lt.lesson_time_id
),
cte2 AS (
	SELECT 
		u.users_id 
	FROM student s
	JOIN users u ON s.user_id = u.users_id
	WHERE patronymic LIKE '%вна'
)
SELECT 
	cte.lesson_id,
	mark_for_lesson,
	cte.FIO,
	avg(cte.mark_for_hw) OVER(PARTITION BY lesson_id) avg_mark
FROM cte, cte2 
WHERE cte.users_id = cte2.users_id
	AND  (cte.year_of_study = 10 AND cte.letter = 'Б');
```
Табличный вид
```
|id |select_type       |table     |partitions|type  |possible_keys              |key                        |key_len|ref                    |rows|filtered|Extra                                                    |
|---|------------------|----------|----------|------|---------------------------|---------------------------|-------|-----------------------|----|--------|---------------------------------------------------------|
|1  |PRIMARY           |u         |          |index |PRIMARY                    |idx_fio                    |2409   |                       |15  |11.11   |Using where; Using index; Using temporary; Using filesort|
|1  |PRIMARY           |s         |          |ref   |idx_fk_student_uesrs       |idx_fk_student_uesrs       |5      |school.u.users_id      |1   |100.0   |Using index                                              |
|1  |PRIMARY           |<derived2>|          |ref   |<auto_key0>                |<auto_key0>                |5      |school.u.users_id      |2   |100.0   |                                                         |
|2  |DERIVED           |l         |          |index |                           |idx_fk_lesson_lesson_time  |5      |                       |1   |100.0   |Using index                                              |
|2  |DERIVED           |je        |          |ref   |idx_fk_journal_entry_lesson|idx_fk_journal_entry_lesson|5      |school.l.lesson_id     |1   |100.0   |                                                         |
|2  |DERIVED           |s         |          |eq_ref|PRIMARY                    |PRIMARY                    |4      |school.je.student_id   |1   |100.0   |                                                         |
|2  |DERIVED           |u         |          |eq_ref|PRIMARY                    |PRIMARY                    |4      |school.s.user_id       |1   |100.0   |Using index                                              |
|2  |DERIVED           |c         |          |eq_ref|PRIMARY                    |PRIMARY                    |4      |school.s.class_id      |1   |33.33   |Using where                                              |
|2  |DERIVED           |lt        |          |eq_ref|PRIMARY                    |PRIMARY                    |4      |school.l.lesson_time_id|1   |100.0   |Using index                                              |
|3  |DEPENDENT SUBQUERY|u2        |          |eq_ref|PRIMARY                    |PRIMARY                    |4      |school.s.user_id       |1   |100.0   |                                                         |

```
В виде дерева
```
-> Window aggregate with buffering: avg(journal_entry.mark_for_hw) OVER (PARTITION BY cte.lesson_id ) 
    -> Sort: cte.lesson_id
        -> Stream results  (cost=4.58 rows=1.67)
            -> Nested loop inner join  (cost=4.58 rows=1.67)
                -> Nested loop inner join  (cost=3.58 rows=1.67)
                    -> Filter: (u.patronymic like '%вна')  (cost=1.75 rows=1.67)
                        -> Covering index scan on u using idx_fio  (cost=1.75 rows=15)
                    -> Covering index lookup on s using idx_fk_student_uesrs (user_id=u.users_id)  (cost=1.06 rows=1)
                -> Index lookup on cte using <auto_key0> (users_id=u.users_id)  (cost=5.79..6.1 rows=2)
                    -> Materialize CTE cte  (cost=5.48..5.48 rows=1)
                        -> Nested loop left join  (cost=5.38 rows=1)
                            -> Filter: ((c.letter = 'Б') and (c.year_of_study = 10))  (cost=4.95 rows=1)
                                -> Nested loop left join  (cost=4.95 rows=1)
                                    -> Nested loop left join  (cost=3.65 rows=1)
                                        -> Nested loop left join  (cost=3.3 rows=1)
                                            -> Nested loop left join  (cost=2.2 rows=1)
                                                -> Covering index scan on l using idx_fk_lesson_lesson_time  (cost=1.1 rows=1)
                                                -> Index lookup on je using idx_fk_journal_entry_lesson (lesson_id=l.lesson_id)  (cost=1.1 rows=1)
                                            -> Single-row index lookup on s using PRIMARY (student_id=je.student_id)  (cost=1.1 rows=1)
                                        -> Single-row covering index lookup on u using PRIMARY (users_id=s.user_id)  (cost=0.35 rows=1)
                                    -> Single-row index lookup on c using PRIMARY (class_id=s.class_id)  (cost=1.03 rows=1)
                            -> Single-row covering index lookup on lt using PRIMARY (lesson_time_id=l.lesson_time_id)  (cost=1.3 rows=1)
                        -> Select #3 (subquery in projection; dependent)
                            -> Single-row index lookup on u2 using PRIMARY (users_id=s.user_id)  (cost=0.35 rows=1)

```
В виде json
```
{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "8.08"
    },
    "windowing": {
      "windows": [
        {
          "name": "<unnamed window>",
          "using_filesort": true,
          "filesort_key": [
            "`lesson_id`"
          ],
          "frame_buffer": {
            "using_temporary_table": true,
            "optimized_frame_evaluation": true
          },
          "functions": [
            "avg"
          ]
        }
      ],
      "cost_info": {
        "sort_cost": "3.33"
      },
      "buffer_result": {
        "using_temporary_table": true,
        "nested_loop": [
          {
            "table": {
              "table_name": "u",
              "access_type": "index",
              "possible_keys": [
                "PRIMARY"
              ],
              "key": "idx_fio",
              "used_key_parts": [
                "name",
                "surname",
                "patronymic"
              ],
              "key_length": "2409",
              "rows_examined_per_scan": 15,
              "rows_produced_per_join": 1,
              "filtered": "11.11",
              "using_index": true,
              "cost_info": {
                "read_cost": "1.58",
                "eval_cost": "0.17",
                "prefix_cost": "1.75",
                "data_read_per_join": "4K"
              },
              "used_columns": [
                "users_id",
                "patronymic"
              ],
              "attached_condition": "(`school`.`u`.`patronymic` like '%вна')"
            }
          },
          {
            "table": {
              "table_name": "s",
              "access_type": "ref",
              "possible_keys": [
                "idx_fk_student_uesrs"
              ],
              "key": "idx_fk_student_uesrs",
              "used_key_parts": [
                "user_id"
              ],
              "key_length": "5",
              "ref": [
                "school.u.users_id"
              ],
              "rows_examined_per_scan": 1,
              "rows_produced_per_join": 1,
              "filtered": "100.00",
              "using_index": true,
              "cost_info": {
                "read_cost": "1.67",
                "eval_cost": "0.17",
                "prefix_cost": "3.58",
                "data_read_per_join": "346"
              },
              "used_columns": [
                "student_id",
                "user_id"
              ]
            }
          },
          {
            "table": {
              "table_name": "cte",
              "access_type": "ref",
              "possible_keys": [
                "<auto_key0>"
              ],
              "key": "<auto_key0>",
              "used_key_parts": [
                "users_id"
              ],
              "key_length": "5",
              "ref": [
                "school.u.users_id"
              ],
              "rows_examined_per_scan": 2,
              "rows_produced_per_join": 3,
              "filtered": "100.00",
              "cost_info": {
                "read_cost": "0.83",
                "eval_cost": "0.33",
                "prefix_cost": "4.75",
                "data_read_per_join": "133"
              },
              "used_columns": [
                "lesson_id",
                "mark_for_lesson",
                "mark_for_hw",
                "users_id",
                "FIO",
                "year_of_study",
                "letter"
              ],
              "materialized_from_subquery": {
                "using_temporary_table": true,
                "dependent": false,
                "cacheable": true,
                "query_block": {
                  "select_id": 2,
                  "cost_info": {
                    "query_cost": "5.12"
                  },
                  "nested_loop": [
                    {
                      "table": {
                        "table_name": "l",
                        "access_type": "index",
                        "key": "idx_fk_lesson_lesson_time",
                        "used_key_parts": [
                          "lesson_time_id"
                        ],
                        "key_length": "5",
                        "rows_examined_per_scan": 1,
                        "rows_produced_per_join": 1,
                        "filtered": "100.00",
                        "using_index": true,
                        "cost_info": {
                          "read_cost": "1.00",
                          "eval_cost": "0.10",
                          "prefix_cost": "1.10",
                          "data_read_per_join": "40"
                        },
                        "used_columns": [
                          "lesson_id",
                          "lesson_time_id"
                        ]
                      }
                    },
                    {
                      "table": {
                        "table_name": "je",
                        "access_type": "ref",
                        "possible_keys": [
                          "idx_fk_journal_entry_lesson"
                        ],
                        "key": "idx_fk_journal_entry_lesson",
                        "used_key_parts": [
                          "lesson_id"
                        ],
                        "key_length": "5",
                        "ref": [
                          "school.l.lesson_id"
                        ],
                        "rows_examined_per_scan": 1,
                        "rows_produced_per_join": 1,
                        "filtered": "100.00",
                        "cost_info": {
                          "read_cost": "1.00",
                          "eval_cost": "0.10",
                          "prefix_cost": "2.20",
                          "data_read_per_join": "24"
                        },
                        "used_columns": [
                          "mark_for_lesson",
                          "mark_for_hw",
                          "student_id",
                          "lesson_id"
                        ]
                      }
                    },
                    {
                      "table": {
                        "table_name": "s",
                        "access_type": "eq_ref",
                        "possible_keys": [
                          "PRIMARY"
                        ],
                        "key": "PRIMARY",
                        "used_key_parts": [
                          "student_id"
                        ],
                        "key_length": "4",
                        "ref": [
                          "school.je.student_id"
                        ],
                        "rows_examined_per_scan": 1,
                        "rows_produced_per_join": 1,
                        "filtered": "100.00",
                        "cost_info": {
                          "read_cost": "1.00",
                          "eval_cost": "0.10",
                          "prefix_cost": "3.30",
                          "data_read_per_join": "208"
                        },
                        "used_columns": [
                          "student_id",
                          "user_id",
                          "class_id"
                        ]
                      }
                    },
                    {
                      "table": {
                        "table_name": "u",
                        "access_type": "eq_ref",
                        "possible_keys": [
                          "PRIMARY"
                        ],
                        "key": "PRIMARY",
                        "used_key_parts": [
                          "users_id"
                        ],
                        "key_length": "4",
                        "ref": [
                          "school.s.user_id"
                        ],
                        "rows_examined_per_scan": 1,
                        "rows_produced_per_join": 1,
                        "filtered": "100.00",
                        "using_index": true,
                        "cost_info": {
                          "read_cost": "0.25",
                          "eval_cost": "0.10",
                          "prefix_cost": "3.65",
                          "data_read_per_join": "2K"
                        },
                        "used_columns": [
                          "users_id"
                        ]
                      }
                    },
                    {
                      "table": {
                        "table_name": "c",
                        "access_type": "eq_ref",
                        "possible_keys": [
                          "PRIMARY"
                        ],
                        "key": "PRIMARY",
                        "used_key_parts": [
                          "class_id"
                        ],
                        "key_length": "4",
                        "ref": [
                          "school.s.class_id"
                        ],
                        "rows_examined_per_scan": 1,
                        "rows_produced_per_join": 0,
                        "filtered": "33.33",
                        "cost_info": {
                          "read_cost": "1.00",
                          "eval_cost": "0.03",
                          "prefix_cost": "4.75",
                          "data_read_per_join": "8"
                        },
                        "used_columns": [
                          "class_id",
                          "letter",
                          "year_of_study"
                        ],
                        "attached_condition": "<if>(found_match(c), ((`school`.`c`.`letter` = 'Б') and (`school`.`c`.`year_of_study` = 10)), true)"
                      }
                    },
                    {
                      "table": {
                        "table_name": "lt",
                        "access_type": "eq_ref",
                        "possible_keys": [
                          "PRIMARY"
                        ],
                        "key": "PRIMARY",
                        "used_key_parts": [
                          "lesson_time_id"
                        ],
                        "key_length": "4",
                        "ref": [
                          "school.l.lesson_time_id"
                        ],
                        "rows_examined_per_scan": 1,
                        "rows_produced_per_join": 0,
                        "filtered": "100.00",
                        "using_index": true,
                        "cost_info": {
                          "read_cost": "0.33",
                          "eval_cost": "0.03",
                          "prefix_cost": "5.12",
                          "data_read_per_join": "5"
                        },
                        "used_columns": [
                          "lesson_time_id"
                        ]
                      }
                    }
                  ],
                  "select_list_subqueries": [
                    {
                      "dependent": true,
                      "cacheable": false,
                      "query_block": {
                        "select_id": 3,
                        "cost_info": {
                          "query_cost": "0.35"
                        },
                        "table": {
                          "table_name": "u2",
                          "access_type": "eq_ref",
                          "possible_keys": [
                            "PRIMARY"
                          ],
                          "key": "PRIMARY",
                          "used_key_parts": [
                            "users_id"
                          ],
                          "key_length": "4",
                          "ref": [
                            "school.s.user_id"
                          ],
                          "rows_examined_per_scan": 1,
                          "rows_produced_per_join": 1,
                          "filtered": "100.00",
                          "cost_info": {
                            "read_cost": "0.25",
                            "eval_cost": "0.10",
                            "prefix_cost": "0.35",
                            "data_read_per_join": "2K"
                          },
                          "used_columns": [
                            "users_id",
                            "name",
                            "surname",
                            "patronymic"
                          ]
                        }
                      }
                    }
                  ]
                }
              }
            }
          }
        ]
      }
    }
  }
}
```

### Оцените план прохождения запроса, найдите самые тяжелые места.
Глядя на план выполнения можно сказать, что самыми тяжелыми местами являются вложенный цикл у последнего джоина внутри cte (т.к. с каждым ждоином растет декартово произведение) и материализация во временную таблицу этого самого cte