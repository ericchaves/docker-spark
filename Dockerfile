FROM gettyimages/spark:latest

MAINTAINER Eric Chaves <eric@uolet.com>

RUN mkdir /var/lib/spark-extras
WORKDIR /var/lib/spark-extras
RUN curl -O http://www.congiu.net/hive-json-serde/1.3.7/hdp23/json-serde-1.3.7-jar-with-dependencies.jar
RUN curl -O http://www.congiu.net/hive-json-serde/1.3.7/hdp23/json-udf-1.3.7-jar-with-dependencies.jar

WORKDIR $SPARK_HOME
CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]
