Я хотел попробовать провести тестирование при помощи сисбенча, но так и не смог его установить в контейнер с докером.
Сначала я проходил внутрь контейнера при помощи
```
docker exec -it otus-mysql-docker-otusdb-1 bash
```
Затем инсталил
```
root@ebbf742ebc12:/# apt install sysbench -y
Reading package lists... Done
Building dependency tree
Reading state information... Done
E: Unable to locate package sysbench
```
Решил проапдейтить apt
```
root@ebbf742ebc12:/# apt update
Ign:1 http://security.debian.org/debian-security stretch/updates InRelease
Ign:2 http://deb.debian.org/debian stretch InRelease
Get:3 http://repo.mysql.com/apt/debian stretch InRelease [21.6 kB]
Err:4 http://security.debian.org/debian-security stretch/updates Release
  404  Not Found [IP: 151.101.66.132 80]
Ign:5 http://deb.debian.org/debian stretch-updates InRelease
Err:3 http://repo.mysql.com/apt/debian stretch InRelease
  The following signatures were invalid: EXPKEYSIG 8C718D3B5072E1F5 MySQL Release Engineering <mysql-build@oss.oracle.com>
Err:6 http://deb.debian.org/debian stretch Release
  404  Not Found
Err:7 http://deb.debian.org/debian stretch-updates Release
  404  Not Found
Reading package lists... Done
E: The repository 'http://security.debian.org/debian-security stretch/updates Release' does not have a Release file.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
W: GPG error: http://repo.mysql.com/apt/debian stretch InRelease: The following signatures were invalid: EXPKEYSIG 8C718D3B5072E1F5 MySQL Release Engineering <mysql-build@oss.oracle.com>
E: The repository 'http://repo.mysql.com/apt/debian stretch InRelease' is not signed.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
E: The repository 'http://deb.debian.org/debian stretch Release' does not have a Release file.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
E: The repository 'http://deb.debian.org/debian stretch-updates Release' does not have a Release file.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
```
Апгрейд apt так же не помог. 
Пробовал через adt-get - такая же проблема.
