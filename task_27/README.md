# PostgreSQL

## Задание

Репликация postgres
- Настроить hot_standby репликацию с использованием слотов
- Настроить правильное резервное копирование

Для сдачи работы присылаем ссылку на репозиторий, в котором должны обязательно быть
- Vagranfile (2 машины)
- плейбук Ansible
- конфигурационные файлы postgresql.conf, pg_hba.conf и recovery.conf,
- конфиг barman, либо скрипт резервного копирования.

Команда "vagrant up" должна поднимать машины с настроенной репликацией и резервным копированием.
Рекомендуется в README.md файл вложить результаты (текст или скриншоты) проверки работы репликации и резервного копирования.

## Проверка

1. Поднимаем vagrant с автоматическим запуском playbook

```bash
vagrant up
```

2. Заходим на сервер master и проверям pg_replication_slots;
```bash
vagrant ssh master
-----
[vagrant@master ~]$ sudo su - postgres
-bash-4.2$ psql
-----
postgres=# select * from pg_replication_slots;
 slot_name | plugin | slot_type | datoid | database | temporary | active | active_pid | xmin | catalog_xmin | restart_lsn | confirmed_flush_lsn 
-----------+--------+-----------+--------+----------+-----------+--------+------------+------+--------------+-------------+---------------------
 slot      |        | physical  |        |          | f         | t      |       6327 |      |              | 0/4000060   | 
 barman    |        | physical  |        |          | f         | t      |       6349 |      |              | 0/4000000   | 
(2 rows)
```
3. Заходим на сервер slave и проверяем что база данных test существует(она была создана при развёртывание на мастере)
```bash
vagrant ssh slave
-----
[vagrant@master ~]$ sudo su - postgres
-bash-4.2$ psql
-----
postgres=# \l+
                                                                    List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   |  Size   | Tablespace |                Description                 
-----------+----------+----------+-------------+-------------+-----------------------+---------+------------+--------------------------------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 7677 kB | pg_default | default administrative connection database
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 7537 kB | pg_default | unmodifiable empty database
           |          |          |             |             | postgres=CTc/postgres |         |            | 
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 7537 kB | pg_default | default template for new databases
           |          |          |             |             | postgres=CTc/postgres |         |            | 
 test      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 7537 kB | pg_default | 
(4 rows)
```
3. Проверяем бэкапы(сервер barman)
```bash
vagrant ssh barman
-----
[vagrant@barman ~]$ sudo su - barman
-----
-bash-4.2$ barman check master
Server master:
        PostgreSQL: OK
        superuser or standard user with backup privileges: OK
        PostgreSQL streaming: OK
        wal_level: OK
        replication slot: OK
        directories: OK
        retention policy settings: OK
        backup maximum age: OK (no last_backup_maximum_age provided)
        compression settings: OK
        failed backups: OK (there are 0 failed backups)
        minimum redundancy requirements: OK (have 0 backups, expected at least 0)
        pg_basebackup: OK
        pg_basebackup compatible: OK
        pg_basebackup supports tablespaces mapping: OK
        systemid coherence: OK (no system Id stored on disk)
        pg_receivexlog: OK
        pg_receivexlog compatible: OK
        receive-wal running: OK
        archiver errors: OK
-bash-4.2$ barman backup master
Starting backup using postgres method for server master in /var/lib/barman/master/base/20210131T161059
Backup start at LSN: 0/4000140 (000000010000000000000004, 00000140)
Starting backup copy via pg_basebackup for 20210131T161059
Copy done (time: 2 seconds)
Finalising the backup.
This is the first backup for server master
WAL segments preceding the current backup have been found:
        000000010000000000000003 from server master has been removed
Backup size: 30.0 MiB
Backup end at LSN: 0/6000000 (000000010000000000000005, 00000000)
Backup completed (start time: 2021-01-31 16:10:59.408461, elapsed time: 2 seconds)
Processing xlog segments from streaming for master
        000000010000000000000004
-bash-4.2$ barman list-backup master
master 20210131T161115 - Sun Jan 31 16:11:17 2021 - Size: 30.0 MiB - WAL Size: 0 B - WAITING_FOR_WALS
```
