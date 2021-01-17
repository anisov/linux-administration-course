# Сетевые пакеты. VLAN'ы. LACP

## Задание
Строим бонды и вланы
в Office1 в тестовой подсети появляется сервера с доп интерфесами и адресами
в internal сети testLAN
- testClient1 - 10.10.10.254
- testClient2 - 10.10.10.254
- testServer1- 10.10.10.1
- testServer2- 10.10.10.1

равести вланами
testClient1 <-> testServer1
testClient2 <-> testServer2

между centralRouter и inetRouter
"пробросить" 2 линка (общая inernal сеть) и объединить их в бонд
проверить работу c отключением интерфейсов

для сдачи - вагрант файл с требуемой конфигурацией
Разворачиваться конфигурация должна через ансибл

## Проверка
**testClient1/2 testServer1/2**
```
[vagrant@testClient2 ~]$ ip r
default via 10.10.10.10 dev vlan2 proto static metric 400 
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 metric 100 
10.10.10.0/24 dev vlan2 proto kernel scope link src 10.10.10.254 metric 400 
[vagrant@testClient2 ~]$ ping 10.10.10.10
PING 10.10.10.10 (10.10.10.10) 56(84) bytes of data.
64 bytes from 10.10.10.10: icmp_seq=1 ttl=64 time=0.772 ms
[vagrant@testClient2 ~]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=57 time=21.1 ms
[vagrant@testClient2 ~]$ sudo yum install traceroute
...
[vagrant@testClient2 ~]$ traceroute 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  gateway (10.10.10.10)  0.685 ms  0.340 ms  0.475 ms
 2  192.168.100.10 (192.168.100.10)  0.983 ms  0.699 ms  0.732 ms
 3  192.168.255.1 (192.168.255.1)  1.918 ms  1.779 ms  1.495 ms
 4  * * *

[vagrant@testServer2 ~]$ ping 10.10.10.254
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=0.513 ms
```

## Запуск
* `vagrant up`

**ОС**: CentOS