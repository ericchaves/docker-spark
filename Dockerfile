FROM gettyimages/spark:latest

MAINTAINER Eric Chaves <eric@uolet.com>

## Just need the HIVE jars to be present
ENV HIVE_VERSION 1.2.1
ENV HIVE_HOME /usr/apache-hive-$HIVE_VERSION-bin
ENV HIVE_CONF_DIR $HIVE_HOME/conf
ENV PATH $PATH:$HIVE_HOME/bin
RUN curl -sL --retry 3 \
  "http://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz" \
  | gunzip \
  | tar -x -C /usr/ \
 && rm -rf $HIVE_HOME/examples $HIVE_HOME/lib/log4j-slf4j-impl-*.jar \
 && chown -R root:root $HIVE_HOME

## Add the SPARK-HIVE jar
RUN curl -sL --retry 3 \
	"http://central.maven.org/maven2/org/apache/spark/spark-hive_2.11/$SPARK_VERSION/spark-hive_2.11-$SPARK_VERSION.jar" \
	 > $SPARK_HOME/jars/"spark-hive_2.11-$SPARK_VERSION.jar"

ENV SPARK_DIST_CLASSPATH="$SPARK_DIST_CLASSPATH:$HIVE_HOME/lib/*"

RUN mkdir /var/lib/spark-extras

WORKDIR $SPARK_HOME
CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]
