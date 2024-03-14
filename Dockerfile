FROM openjdk:8-jdk
ENV JAVA_HOME=/usr/local/openjdk-8


# Установка Python и Pip
RUN apt-get update && apt-get install -y python3 python3-pip


# Установка Hadoop
ENV HADOOP_VERSION 3.2.2
ENV HADOOP_HOME /usr/local/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
RUN curl -L https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz -o hadoop-$HADOOP_VERSION.tar.gz && \
    tar -xzf hadoop-$HADOOP_VERSION.tar.gz && \
    mv hadoop-$HADOOP_VERSION $HADOOP_HOME && \
    rm hadoop-$HADOOP_VERSION.tar.gz


# Установка Spark
ENV SPARK_VERSION 3.3.4
ENV SPARK_HOME /usr/local/spark
ENV PATH $PATH:$SPARK_HOME/bin
RUN curl -L https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz -o spark-$SPARK_VERSION-bin-hadoop3.tgz && \
    tar -xzf spark-$SPARK_VERSION-bin-hadoop3.tgz && \
    mv spark-$SPARK_VERSION-bin-hadoop3 $SPARK_HOME && \
    rm spark-$SPARK_VERSION-bin-hadoop3.tgz


# Установка PySpark
RUN pip3 install pyspark==$SPARK_VERSION


# Копирование конфигурационных файлов Hadoop и Spark
COPY hadoop-config/* $HADOOP_HOME/etc/hadoop/
COPY spark-config/* $SPARK_HOME/conf/


# Запуск Hadoop
RUN $HADOOP_HOME/bin/hdfs namenode -format
COPY start-hadoop.sh /usr/local/bin/start-hadoop.sh
RUN chmod +x /usr/local/bin/start-hadoop.sh


COPY data/yelp_academic_dataset_business.json /usr/local/data/yelp/business/yelp_academic_dataset_business.json
COPY data/yelp_academic_dataset_checkin.json /usr/local/data/yelp/checkin/yelp_academic_dataset_checkin.json
COPY data/review/* /usr/local/data/yelp/review/
COPY tasks /usr/local/tasks/
RUN chmod +x /usr/local/tasks/mapreduce/task1/*
RUN chmod +x /usr/local/tasks/mapreduce/task2/*
RUN chmod +x /usr/local/tasks/spark/spark-df/task1/*
RUN chmod +x /usr/local/tasks/spark/spark-df/task2/*
RUN chmod +x /usr/local/tasks/spark/spark-rdd/task1/*
RUN chmod +x /usr/local/tasks/spark/spark-rdd/task2/*

RUN echo "export JAVA_HOME=/usr/local/openjdk-8" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop

# Открытие необходимых портов
EXPOSE 8080 9870 9000

# Запуск Hadoop при старте контейнера
CMD ["/usr/local/bin/start-hadoop.sh"]
