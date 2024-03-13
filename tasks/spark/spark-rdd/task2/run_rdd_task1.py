from pyspark import SparkContext, SparkConf

import json
from datetime import timedelta
import sys

config = SparkConf().setAppName("WordCount").setMaster("yarn").set("spark.executor.instances", "2").set("spark.executor.cores", "1").set('spark.executor.memory', '1g')
sc = SparkContext(conf=config)

OUT_PATH=sys.argv[1]


business = sc.textFile('/data/yelp/business')
business_json = business.map(lambda x: json.loads(x))

def hours(business_json):
    week_list = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    business_id = business_json['business_id']
    if 'hours' in business_json and business_json["hours"] is not None and int(business_json["is_open"]) == 1:
        counter = 0  
        
        for week_day in week_list:
            if week_day in business_json["hours"]:
                hours = business_json["hours"][week_day]
                hours_list = hours.split('-')
                start_time_list = hours_list[0].split(':')
                start_time = timedelta(hours=int(start_time_list[0]), minutes=int(start_time_list[1]))
                end_time_list = hours_list[1].split(':')
                end_time = timedelta(hours=int(end_time_list[0]), minutes=int(end_time_list[1]))
                work_hours = end_time - start_time
                work_hours = int(work_hours.seconds/60)
                counter += work_hours
                
        return (
            business_id,
            counter
        ) 
    else:
        return (
            business_id,
            0
        ) 


business_hours = business_json.map(hours)

business_top = business_hours.sortBy(lambda x: (-x[1], x[0]))


business_top_string = business_top.map(lambda x: f'{x[0]}\t{x[1]}')

for line in business_top_string.take(10):
    print(line)
    
business_top_string.saveAsTextFile(OUT_PATH)