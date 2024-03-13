#!/usr/bin/env bash

OUT_DIR=$1

NUM_REDUCERS=1

# Delete previous directory
# hdfs dfs -rm -r -skipTrash $OUT_DIR*
if hdfs dfs -test -d $OUT_DIR; then
   hdfs dfs -rm -r -skipTrash $OUT_DIR
fi

# Running yarn jar
yarn jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.2.2.jar \
    -D mapreduce.job.name="ledneva_task1" \
    -D mapreduce.job.reduces=${NUM_REDUCERS} \
    -files mapper.py,reducer.py \
    -mapper "./mapper.py" \
    -reducer "./reducer.py" \
    -input /data/yelp/business \
    -combiner "./reducer.py" \
    -output $OUT_DIR


# Checking the results
for num in `seq 0 $(($NUM_REDUCERS - 1))`
do
    hdfs dfs -cat ${OUT_DIR}/part-0000$num | head
done