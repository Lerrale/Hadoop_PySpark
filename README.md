# Docker образ с HDFS и Spark для обучения и тренировки

Этот репозиторий содержит код для сборки Docker образа с HDFS и Spark, предназначенного для тренировочных целей. Включает в себя задачи с решениями, выполненные во время обучения в магистратуре МФТИ.


## Особенности
- Образ включает в себя предварительно настроенные HDFS, MapReduce и Spark для учебных и тренировочных целей на одной локальной машине.
- Образ включает в себя папку с задачами и решениями по темам MapReduce, Spark DF, и Spark RDD. Описание самих задач находится в соответствующих папках.
- В репозиторий приложена папка `tasks_solutions`, содержащая файлы, которые были получены в результате решения задач.
- Папка с данными не добавлена в репозиторий из за большого размера. Ее можно отдельно скачать по ссылке и добавить в корневую папку
- Можно воспроизвести решение задач, запустив их из контейнера.
  
## Структура проекта

- **tasks_solutions/**: Папка с файлами, которые были созданы в результате выполнения задач. Эти файлы представляют собой данные, которые должны были быть сохранены в HDFS согласно условиям задач.
- **tasks/**: Папка с задачами на MapReduce, Spark DF, и Spark RDD. Условия задач находятся внутри.
- **hadoop-config**
- **spark-config**
- **Dockerfile**
- **start-hadoop.sh**

## Сборка Docker образа

1) Чтобы собрать Docker образ необходимо:
   - скопировать репозиторий
   - скачать папку data и добавить ее в корень проекта.
     ссылка для скачивания:
     по ссылке https://drive.google.com/file/d/1wAVE3pnluh_uZOzgsH5QtpoUyfXzr8o_/view?usp=sharing 
   - запустить следующую команду из корня проекта:
```bash
docker build -t <имя_образа> .
```
2) Или скачать полностью готовый образ:
```bash
docker pull lerrale/hadoop_pyspark:latest
```
## Запуск задач
Задачи лежат в директории /usr/local/tasks/ .
Запуск решения каждой задачи должен происходить из папки с задачей в формате:
```bash
./run.sh <output_folder>
```






