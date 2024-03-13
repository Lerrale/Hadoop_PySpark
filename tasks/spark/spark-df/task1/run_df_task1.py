from pyspark.sql import SparkSession
import pyspark.sql.functions as f
from pyspark.sql import Window
import sys

OUT_PATH=sys.argv[1]

spark = SparkSession.builder.appName('Spark DF task1').master('yarn').getOrCreate()

business = (spark.read.format("json")
    .load("/data/yelp/business")
)

review = spark.read.json('/data/yelp/review')

spark.sql("SET spark.sql.autoBroadcastJoinThreshold = 10")
business_review = review.join(f.broadcast(business.drop('stars')), on='business_id', how='inner')

business_review_processed = business_review.select(["business_id", "city", "stars"])
business_review_processed = business_review_processed.filter("stars <3")
business_review_grouped = business_review_processed.groupby(["business_id", "city"]).agg(f.count('stars'))
business_review_rank = business_review_grouped.select("business_id", "city", 'count(stars)', f.rank().over(
    Window.partitionBy('city').orderBy(f.col('count(stars)').desc())
).alias('rank'))

business_review_rank = business_review_rank.select(
    business_review_rank.business_id,
    business_review_rank.city,
    business_review_rank.rank,
    business_review_rank['count(stars)'].alias("stars")
    )

business_review_rank.registerTempTable("business_review_rank")
query_str = """
SELECT business_review_rank.business_id, business_review_rank.city, business_review_rank.stars      
FROM business_review_rank
WHERE business_review_rank.rank<=10
"""
rating = spark.sql(query_str)

rating.write.csv(OUT_PATH, sep='\t', mode='overwrite')

