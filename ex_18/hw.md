#### Физическая репликация
Я создал второй кластер
```
root@5489c1deadc6:/# pg_createcluster -d /var/lib/postgresql/data2 14 data2
Creating new PostgreSQL cluster 14/data2 ...
/usr/lib/postgresql/14/bin/initdb -D /var/lib/postgresql/data2 --auth-local peer --auth-host scram-sha-256 --no-instructions
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

The database cluster will be initialized with locale "en_US.utf8".
The default database encoding has accordingly been set to "UTF8".
The default text search configuration will be set to "english".

Data page checksums are disabled.

fixing permissions on existing directory /var/lib/postgresql/data2 ... ok
creating subdirectories ... ok
selecting dynamic shared memory implementation ... posix
selecting default max_connections ... 100
selecting default shared_buffers ... 128MB
selecting default time zone ... Etc/UTC
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok
Ver Cluster Port Status Owner    Data directory            Log file
14  data2   5433 down   postgres /var/lib/postgresql/data2 /var/log/postgresql/postgresql-14-data2.log
```
Отчистил директорию и создал в ней файлы бекапа
```
root@5489c1deadc6:/# rm -rf /var/lib/postgresql/data2
root@5489c1deadc6:/# pg_basebackup -U postgres -p 5432 -R -D /var/lib/postgresql/data2
```
Выдал права на папку, т.к. под рутом рестартиться не давал
```
root@5489c1deadc6:/# chown -R postgres /var/lib/postgresql/data2
root@5489c1deadc6:/# pg_ctlcluster 14 data2 restart
```
Проверяю кластеры, отображается почему-то только новый. На самом деле их 2. Я думаю это проблемы версии из докера.
```
root@5489c1deadc6:/# pg_lsclusters
Ver Cluster Port Status          Owner    Data directory            Log file
14  data2   5433 online,recovery postgres /var/lib/postgresql/data2 /var/log/postgresql/postgresql-14-data2.log
```
Проверка двух кластеров. База otus создалась при развертывании контейнера через docker-compose.
```
root@5489c1deadc6:/# psql -d postgres -p 5432 -U postgres -W postgres
psql: warning: extra command-line argument "postgres" ignored
Password:
psql (14.9 (Debian 14.9-1.pgdg120+1))
Type "help" for help.

postgres=# \conninfo
You are connected to database "postgres" as user "postgres" via socket in "/var/run/postgresql" at port "5432".
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 otus      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(4 rows)
```
Зайти на второй получилось только из под пользователя postgres
```
root@5489c1deadc6:/# su postgres
postgres@5489c1deadc6:/$ psql
psql (14.9 (Debian 14.9-1.pgdg120+1))
Type "help" for help.

postgres=# \conninfo
You are connected to database "postgres" as user "postgres" via socket in "/var/run/postgresql" at port "5433".
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 otus      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(4 rows)
```
Проверка работы репликации
```
root@5489c1deadc6:/# psql -d otus -p 5432 -U postgres -W postgres
psql: warning: extra command-line argument "postgres" ignored
Password:
psql (14.9 (Debian 14.9-1.pgdg120+1))
Type "help" for help.

otus=# insert into students values(11, 'satilin');
INSERT 0 1
otus=# select * from students;
 id |    fio
----+------------
  1 | c411b36077
  2 | 34df9ce716
  3 | 84150d08f4
  4 | c619c03898
  5 | 3e69c10cae
  6 | c31d2354af
  7 | 6b89f3823f
  8 | 2d94874fd5
  9 | 008a0b9c41
 10 | 5b1d75580a
 11 | satilin
(11 rows)

otus=# \q
root@5489c1deadc6:/# su postgres
postgres@5489c1deadc6:/$ psql
psql (14.9 (Debian 14.9-1.pgdg120+1))
Type "help" for help.

postgres=# \c otus
You are now connected to database "otus" as user "postgres".
otus=# select * from students;
 id |    fio
----+------------
  1 | c411b36077
  2 | 34df9ce716
  3 | 84150d08f4
  4 | c619c03898
  5 | 3e69c10cae
  6 | c31d2354af
  7 | 6b89f3823f
  8 | 2d94874fd5
  9 | 008a0b9c41
 10 | 5b1d75580a
 11 | satilin
(11 rows)
```
Для того чтобы была задержка, необходимо было добавить в файл postgresql.conf реплики соответсвующую настройку, и затем перезапустить экземпляр
```
root@5489c1deadc6:/# echo "recovery_min_apply_delay = 5min" >> /var/lib/postgresql/data2/postgresql.conf
root@5489c1deadc6:/# service postgresql restart
Restarting PostgreSQL 14 database server: data2.
```

#### Логическая репликация
Я так и не смог понять где находится мой первый кластер, поэтому по аналогии с физической репликацией создал еще один кластер data3, не забыв убрать флаг -R, чтобы он не стал репликой.
```
postgres@5489c1deadc6:/$ pg_lsclusters
Ver Cluster Port Status          Owner    Data directory            Log file
14  data2   5433 online,recovery postgres /var/lib/postgresql/data2 /var/log/postgresql/postgresql-14-data2.log
14  data3   5434 online          postgres /var/lib/postgresql/data3 /var/log/postgresql/postgresql-14-data3.log
```
Отчистил таблицу со студентами на новом кластере
```
postgres@5489c1deadc6:/$ psql -d postgres -p 5434 -U postgres
psql (14.9 (Debian 14.9-1.pgdg120+1))
Type "help" for help.

postgres=# \c otus
You are now connected to database "otus" as user "postgres".
otus=# select * from students ;
 id | fio
----+-----
(0 rows)
```
Изменил уровень WAL логов и рестартанул кластер
```
otus=# alter system set wal_level = logical;
ALTER SYSTEM
otus=# \q
postgres@5489c1deadc6:/$ pg_ctlcluster 14 data3 restart
```
Создал публикацию
```
otus=# show wal_level ;
 wal_level
-----------
 logical
(1 row)

otus=# create publication test_pub for table students;
CREATE PUBLICATION
```
При попытке создать подписку на реплике посгрес выдавал ошибку
```
ERROR:  cannot execute CREATE SUBSCRIPTION in a read-only transaction
```
Для исправления я удалил файл standby.signal из реплики и перезапустил кластер
```
root@5489c1deadc6:/# rm /var/lib/postgresql/data2/standby.signal
root@5489c1deadc6:/# pg_ctlcluster 14 data2 restart
```
После этого подписка создалась без ошибок
```
otus=# create subscription test_sub
connection 'host=localhost port=5434 user=postgres password=postgres dbname=otus'
publication test_pub with (copy_data = true);
NOTICE:  created replication slot "test_sub" on publisher
CREATE SUBSCRIPTION
```
Вставляю значение в таблицу на мастере
```
postgres@5489c1deadc6:/$ psql -d otus -p 5434 -U postgres
psql (14.9 (Debian 14.9-1.pgdg120+1))
Type "help" for help.

otus=# insert into students values (13, 'clown')
otus-# ;
INSERT 0 1
otus=# select * from students ;
 id |    fio
----+------------
 13 | clown
(1 row)
```
Проверяю наличие копии строки на реплике 
```
postgres@5489c1deadc6:/$ psql -d otus -p 5433 -U postgres
psql (14.9 (Debian 14.9-1.pgdg120+1))
Type "help" for help.

otus=# select * from students ;
 id |    fio
----+------------
  1 | c411b36077
  2 | 34df9ce716
  3 | 84150d08f4
  4 | c619c03898
  5 | 3e69c10cae
  6 | c31d2354af
  7 | 6b89f3823f
  8 | 2d94874fd5
  9 | 008a0b9c41
 10 | 5b1d75580a
 11 | satilin
 12 | aaaaaaa
 13 | clown
(13 rows)
```
