### Требуется восстановить таблицу world.city из бэкапа и выполнить оператор: select count(*) from city where countrycode = 'RUS';
Скачал и перенес архив в контейнер, в папку /tmp/backup
Остановил базу и очистил папку с данными mysql
```
systemctl stop mysql
rm -rf /var/lib/mysql/*
```
Разшифровал и разархивировал архив с бекапом
```
cd /tmp/backup
openssl des3 -salt -k "password" -d -in backup_des.xbstream.gz.des3 -out backup_des.xbstream.gz
gzip -d stream/backup_des.xbstream.gz
```
Извлек файлы бекапа в папку 
```
cd stream
xbstream -x < backup_des.xbstream
```
Подготовил и применил бекап
```
xtrabackup --prepare --export --target-dir=/tmp/backup/stream
xtrabackup --copy-back --target-dir=/tmp/backup/stream --datadir=/var/lib/mysql
```
Выдал права на папку с данными mysql и запустил сервис
```
chown -R mysql.mysql /var/lib/mysql
systemctl start mysql
```
Выполнил селект
```
mysql -u root -p world -e "select count(*) from city where countrycode = 'RUS';"
```
Результат отправил в чат с преподавателем