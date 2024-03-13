export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_PYTHON=/bin/python3 # вот тут нужно подумать может быть /bin/python3
export PYSPARK_DRIVER_PYTHON_OPTS='notebook --port=23044 --no-browser'
export SPARK_KAFKA_VERSION=0.11
export SPARK_LOCAL_IP=10.128.0.34
pyspark --master=yarn --num-executors=2 --master local[2]
