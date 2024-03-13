#!/usr/bin/env bash

OUT_DIR=$1

NUM_REDUCERS=1

# Delete previous directory
hdfs dfs -rm -r -skipTrash $OUT_DIR*

# Running yarn jar
yarn jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.2.2.jar \
    -D mapreduce.job.name="ledneva_task2" \
    -D mapreduce.job.reduces=${NUM_REDUCERS} \
    -D stream.num.map.output.key.fields=2 \
    -D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator \
    -D mapred.text.key.comparator.options="-k2,2nr -k1,1" \
    -files mapper.py,reducer.py \
    -mapper "./mapper.py" \
    -reducer "./reducer.py" \
    -input /data/yelp/business \
    -combiner "./reducer.py" \
    -output $OUT_DIR


# Checking the results
for num in `seq 0 $(($NUM_REDUCERS - 1))`
do
    hdfs dfs -cat ${OUT_DIR}/part-0000$num | head -n 10
done