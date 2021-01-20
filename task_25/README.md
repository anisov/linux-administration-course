# LDAP. Централизованная авторизация и аутентификация

## Задание
* Установить FreeIPA;
* Написать Ansible playbook для конфигурации клиента;
* Настроить аутентификацию по SSH-ключам;*

## Проверка
`vagrant ssh ipaclient`

**ipaclient**
```
Last login: Wed Jan 20 15:36:26 2021 from 10.0.2.2
[vagrant@ipaclient ~]$ sudo su -  dmitriy
Last login: Wed Jan 20 15:36:32 MSK 2021 on pts/0
[dmitriy@ipaclient ~]$ ssh dmitriy@192.168.1.1
Creating home directory for dmitriy.
-sh-4.2$
```

## Запуск
* `vagrant up`

**ОС**: CentOS