# Домашнее задание к занятию 14 «Средство визуализации Grafana»

## Задание повышенной сложности

**При решении задания 1** не используйте директорию [help](./help) для сборки проекта. Самостоятельно разверните grafana, где в роли источника данных будет выступать prometheus, а сборщиком данных будет node-exporter:

- grafana;
- prometheus-server;
- prometheus node-exporter.

За дополнительными материалами можете обратиться в официальную документацию grafana и prometheus.

В решении к домашнему заданию также приведите все конфигурации, скрипты, манифесты, которые вы 
использовали в процессе решения задания.

---
![monitoring](https://github.com/valdemar-2502/Grafana-visualization-tool---Homework/blob/main/screenshots/01.png)
![monitoring](https://github.com/valdemar-2502/Grafana-visualization-tool---Homework/blob/main/screenshots/02.png)
![monitoring](https://github.com/valdemar-2502/Grafana-visualization-tool---Homework/blob/main/screenshots/03.png)
![monitoring](https://github.com/valdemar-2502/Grafana-visualization-tool---Homework/blob/main/screenshots/04.png)
![monitoring](https://github.com/valdemar-2502/Grafana-visualization-tool---Homework/blob/main/screenshots/09.png)
![monitoring](https://github.com/valdemar-2502/Grafana-visualization-tool---Homework/blob/main/screenshots/10.png)


---
[install-monitoring.sh](https://github.com/valdemar-2502/Grafana-visualization-tool---Homework/blob/main/install-monitoring.sh)


---
**При решении задания 3** вы должны самостоятельно завести удобный для вас канал нотификации, например, Telegram или email, и отправить туда тестовые события.

В решении приведите скриншоты тестовых событий из каналов нотификаций.

---
![monitoring](https://github.com/valdemar-2502/Grafana-visualization-tool---Homework/blob/main/screenshots/06.png)
![monitoring](https://github.com/valdemar-2502/Grafana-visualization-tool---Homework/blob/main/screenshots/07.png)

---

## Обязательные задания

### Задание 1

1. Используя директорию [help](./help) внутри этого домашнего задания, запустите связку prometheus-grafana.
1. Зайдите в веб-интерфейс grafana, используя авторизационные данные, указанные в манифесте docker-compose.
1. Подключите поднятый вами prometheus, как источник данных.
1. Решение домашнего задания — скриншот веб-интерфейса grafana со списком подключенных Datasource.

## Задание 2

Изучите самостоятельно ресурсы:

1. [PromQL tutorial for beginners and humans](https://valyala.medium.com/promql-tutorial-for-beginners-9ab455142085).
2. [Understanding Machine CPU usage](https://www.robustperception.io/understanding-machine-cpu-usage).
3. [Introduction to PromQL, the Prometheus query language](https://grafana.com/blog/2020/02/04/introduction-to-promql-the-prometheus-query-language/).

Создайте Dashboard и в ней создайте Panels:

- утилизация CPU для nodeexporter (в процентах, 100-idle);
- CPULA 1/5/15;
- количество свободной оперативной памяти;
- количество места на файловой системе.

Для решения этого задания приведите promql-запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

---
![monitoring](https://github.com/valdemar-2502/Grafana-visualization-tool---Homework/blob/main/screenshots/08.png)
![monitoring](https://github.com/valdemar-2502/Grafana-visualization-tool---Homework/blob/main/screenshots/11.png)
![monitoring](https://github.com/valdemar-2502/Grafana-visualization-tool---Homework/blob/main/screenshots/12.png)
![monitoring](https://github.com/valdemar-2502/Grafana-visualization-tool---Homework/blob/main/screenshots/13.png)

---


## Задание 3

1. Создайте для каждой Dashboard подходящее правило alert — можно обратиться к первой лекции в блоке «Мониторинг».
2. В качестве решения задания приведите скриншот вашей итоговой Dashboard.

---
![monitoring](https://github.com/valdemar-2502/Grafana-visualization-tool---Homework/blob/main/screenshots/14.png)

---

## Задание 4

1. Сохраните ваш Dashboard.Для этого перейдите в настройки Dashboard, выберите в боковом меню «JSON MODEL». Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
2. В качестве решения задания приведите листинг этого файла.

---

[node-exporter-dashboard.json](https://github.com/valdemar-2502/Grafana-visualization-tool---Homework/blob/main/node-exporter-dashboard.json)


---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
