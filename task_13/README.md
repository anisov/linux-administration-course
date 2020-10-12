# Задание

## Работа с SELinux

**Цель: Тренируем умение работать с SELinux: диагностировать проблемы и модифицировать политики SELinux для корректной работы приложений, если это требуется.**

* **Запустить nginx на нестандартном порту 3-мя разными способами:**
  1. переключатели setsebool;
  2. добавление нестандартного порта в имеющийся тип;
  3. формирование и установка модуля SELinux.
     К сдаче:
  4. README с описанием каждого решения (скриншоты и демонстрация приветствуются).
* **Обеспечить работоспособность приложения при включенном selinux.**
  1. Развернуть приложенный стенд
     https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems
  2. Выяснить причину неработоспособности механизма обновления зоны (см. README);
  3. Предложить решение (или решения) для данной проблемы;
  4. Выбрать одно из решений для реализации, предварительно обосновав выбор;
  5. Реализовать выбранное решение и продемонстрировать его работоспособность.
     К сдаче:
     1. README с анализом причины неработоспособности, возможными способами решения и обоснованием выбора одного из них;
     2. Исправленный стенд или демонстрация работоспособной системы скриншотами и описанием.

## Решение

### Запустить nginx на нестандартном порту разными способами

`1_script.sh` -> Скрипт выполняющий все действий, которые описаны ниже. Запуск: `sudo /vagrant/./1_script.sh`

Устанавливаем все необходимые пакеты и запускаем nginx.

```
yum install -y epel-release
yum install -y setools setroubleshoot-server nginx
systemctl enable nginx --now  
systemctl status nginx  
```

Убеждаемся, что nginx слушает на 80 порту.

```
ss -tulpn | column -t | grep nginx  ss -tulpn | column -t | grep nginx  
```

Добавляем дополнительный порт на котором nginx должен принимать запросы, перезапускаем его и проверяем, что он не работает.

```
sed -i '/listen       80 default_server;/a \\tlisten       6781 ;' /etc/nginx/nginx.conf
systemctl restart nginx  
systemctl status nginx
```

**Решение 1.**

Добавляем порт 6781 в http_port_t и смотрим изменения.

```
semanage port -a -t http_port_t -p tcp 6781
semanage port -l | grep http  
```

Перезапускаем nginx и проверяем работоспособность.

```
systemctl restart nginx.service
systemctl status nginx  
ss -tulpn | column -t | grep nginx
```

**Решение 2.**

Удаляем порт из http_port_t и обнуляем audit.log.

```
semanage port -d -t http_port_t -p tcp 6781
echo > /var/log/audit/audit.log
```

Перезапускаем nginx и проверяем статус, который сообщит, что nginx опять не работает.

```
systemctl restart nginx  
systemctl status nginx
```

Формируем модуль на основе лога с помощью ausearch и audit2allow.

```
ausearch -c "nginx" --raw | audit2allow -M se-nginx  
```

Устанавливаем модуль, презапускаем nginx и проверяем статус.

```
semodule -i se-nginx.pp  
systemctl restart nginx
systemctl status nginx  
ss -tulpn | column -t | grep nginx 
```

### Обеспечить работоспособность приложения при включенном selinux.
После запуска и выполнения необходимых команд на клиенте, у dns сервере мы можем увидеть проблему в `var/log/audit/audit.log`, которая указывает на неверные тип контекста для файлов содержащих записи зон.

**Решение:**
* Выполняем команду и узнаем причину: `audit2why < /var/log/audit/audit.log`:
   ```
   type=AVC msg=audit(1602508518.573:1963): avc:  denied  { create } for  pid=5301 comm="isc-worker0000" name="named.ddns.lab.view1.jnl" scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:etc_t:s0 tclass=file permissive=0

         Was caused by:
                  Missing type enforcement (TE) allow rule.

                  You can use audit2allow to generate a loadable module to allow this access.
   ```
* Генерируем новые политики для SELinux на основе журнала audit.log: `audit2allow -M selinux --debug < /var/log/audit/audit.log`
* Применяем данный модуль: `semodule -i selinux.pp`
* Перезапускаем сервсис: `systemctl restart named` и попробуем ещё раз. Не получилось.
* Пытаемся узнать причину: `audit2why < /var/log/audit/audit.log`. Видим туже проблему, но с другим пояснением.
   ```
   type=AVC msg=audit(1602508518.573:1963): avc:  denied  { create } for  pid=5301 comm="isc-worker0000" name="named.ddns.lab.view1.jnl" scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:etc_t:s0 tclass=file permissive=0

         Was caused by:
                  Unknown - would be allowed by active policy
                  Possible mismatch between this policy and the one under which the audit message was generated.

                  Possible mismatch between current in-memory boolean settings vs. permanent ones.
   ```
* Смотрим тип контекста файлов: `ls -Z /etc/named/dynamic/`
* Меняем тип контекста файлов: 
   ```
   chcon -R -t named_zone_t /etc/named/dynamic/
   semanage fcontext -a -t named_zone_t /etc/named/dynamic/
   ```
* Удаляем: `rm -rf /etc/named/dynamic/named.ddns.lab.view1.jnl`
* Перезапускаем сервис: `systemctl restart named`. Пробуем. Теперь всё проходит успешно.


## Запуск

* `vagrant up`

**ОС**: CentOS
