#!/bin/bash

# Установка переменной JAVA_HOME
export JAVA_HOME=/usr/local/openjdk-8

# Определение пользователей для Hadoop и YARN демонов
export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root

# Запуск HDFS демонов: NameNode и DataNode
$HADOOP_HOME/bin/hdfs --daemon start namenode
$HADOOP_HOME/bin/hdfs --daemon start datanode

# Запуск YARN демонов: ResourceManager и NodeManager
$HADOOP_HOME/bin/yarn --daemon start resourcemanager
$HADOOP_HOME/bin/yarn --daemon start nodemanager


hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/root
hdfs dfs -mkdir /user/root/find / -name example.txt
hdfs dfs -mkdir /data
hadoop fs -copyFromLocal /usr/local/data/* /data/

# Держать контейнер в работающем состояниим
tail -f /dev/null


