# Задание

## Работа с LVM
На имеющемся образе
/dev/mapper/VolGroup00-LogVol00 38G 738M 37G 2% /

1) уменьшить том под / до 8G
2) выделить том под /home
3) выделить том под /var
4) /var - сделать в mirror
5) /home - сделать том для снэпшотов
6) прописать монтирование в fstab
7) попробовать с разными опциями и разными файловыми системами (на выбор):
    * сгенерить файлы в /home/
    * снять снэпшот
    * удалить часть файлов
    * восстановится со снэпшота

## Запуск.

1) vagrant up 
2) vagrant ssh -> sudo su -> cd /vagrant && ./script_1.sh
2) vagrant ssh -> sudo su -> cd /vagrant && ./script_2.sh
2) vagrant ssh -> sudo su -> cd /vagrant && ./script_3.sh
2) vagrant ssh -> sudo su -> cd /vagrant && ./script_4.sh

**ОС**: CentOS.
