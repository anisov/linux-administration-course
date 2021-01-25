# Динамический веб

## Задание
Развернуть стенд с веб приложениями в vagrant
Варианты стенда
nginx + php-fpm (laravel/wordpress) + python (flask/django) + js(react/angular)
nginx + java (tomcat/jetty/netty) + go + ruby
можно свои комбинации

Реализации на выбор
- на хостовой системе через конфиги в /etc
- деплой через docker-compose

Для усложнения можно попросить проекты у коллег с курсов по разработке

К сдаче примается
vagrant стэнд с проброшенными на локалхост портами
каждый порт на свой сайт
через нжинкс

## Проверка
* Запуск `vagrant up`
* В `/etc/hosts ` прописать следующее:
```
0.0.0.0 test.local
0.0.0.0 python.test.local
0.0.0.0 golang.test.local
```
* Первый вариант: открыть для проверки в браузере: `http://python.test.local:3000` / `http://golang.test.local:3000`
* Второй вариант: `http://test.local:3000/python/` / `http://test.local:3000/python/`

**ОС**: CentOS