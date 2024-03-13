from pyspark.sql import SparkSession
import pyspark.sql.functions as f
import sys

OUT_PATH=sys.argv[1]

spark = SparkSession.builder.appName('Spark DF task1').master('yarn').getOrCreate()


business = (spark.read.format("json")
    .load("/data/yelp/business")
)
checkins = (spark.read.format("json")
    .load("/data/yelp/checkin")
)

business_shot = business.select("business_id", "categories")
business_parsed = business_shot.withColumn("category", f.explode(f.split(business_shot["categories"], ", ")))
business_parsed = business_parsed.select("business_id", "category")

spark.sql("SET spark.sql.autoBroadcastJoinThreshold = 10")
business_checkins = business_parsed.join(f.broadcast(checkins), on='business_id', how='inner')

business_checkins_parsed = business_checkins.withColumn("checkin_date", f.explode(f.split(business_checkins["date"], ", ")))
business_checkins_parsed = business_checkins_parsed.select("business_id", "category", "checkin_date")
business_checkins_month = business_checkins_parsed.withColumn("year_month", f.date_format("checkin_date", "yyyy-MM"))

business_checkins_month.registerTempTable("business_checkins_month")
query_str = """
SELECT year_month,
       category, 
       count(checkin_date)
FROM business_checkins_month
GROUP BY year_month, category
ORDER BY year_month, category
"""

statistic = spark.sql(query_str)
statistic.write.csv(OUT_PATH, sep='\t', mode='overwrite')


