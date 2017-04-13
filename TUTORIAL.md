Spark Dojo
=========


1. clone do repositorio e cd spark-dojo
2. baixar dados de exemplo ```curl -o ./data/ol_cdump.json  https://s3-eu-west-1.amazonaws.com/csparkdata/ol_cdump.json```
3. iniciar o cluster ```docker-compose up -d```
4. acessar o cluster em pyspark shell ```docker exec -it dockerspark_master_1 bin/pyspark```
5. após concluir o bloco de instruções, encerrar os containers com ``docker-compose down```

### Spark RDD, transformations e actions

   path = "file:///tmp/data/ol_cdump.json"
   raw_data = sc.textFile(path)
   raw_data
   >> file://tmp/data/ol_cdump.json MapPartitionsRDD[1] at textFile at NativeMethodAccessorImpl.java:0

   import json
   dataset = raw_data.map(json.loads)
   dataset.persist()
   >> PythonRDD[2] at RDD at PythonRDD.scala:48

   dataset.count()
   >> 148163
   dataset.take(10)

   keys = dataset.flatMap(lambda d: d.keys()).distinct().collect()
   len(keys)
   >> 77
   keys
   >> ['excerpts', 'edition_name', 'series',..., 'weight']

   groups = dataset.map(lambda e: (len(e.keys()), e)).groupByKey()
   groups.count()
   >> 29

   count_per_key = (
    dataset
    .map(lambda e: (len(e.keys()), 1))
    .reduceByKey(lambda x, y: x + y)
    .collect()
   )
   count_per_key
   >> [(25, 6976), (10, 1411), (20, 19359), (30, 136), (15, 2449), (16, 4138), (21, 22445), (6, 233), (26, 4107), (11, 666), (31, 46), (32, 14), (17, 6800), (22, 19422), (7, 1022), (27, 2215), (12, 890), (33, 7), (18, 9209), (23, 15460), (8, 805), (28, 1068), (13, 2206), (34, 2), (19, 13039), (24, 10765), (9, 1166), (29, 466), (14, 1641)]

   for x in groups.collect():
     print(x)
  
   >> (25, <pyspark.resultiterable.ResultIterable object at 0x7f73ad4036d8>)
   >> (10, <pyspark.resultiterable.ResultIterable object at 0x7f73a650b128>)
   CTRL+D

### SparkSession, novo contexto

1. antes de iniciar este bloco baixe os arquivos de JSON SerDe:
```
  cd jars
  curl -O http://www.congiu.net/hive-json-serde/1.3.7/hdp23/json-serde-1.3.7-jar-with-dependencies.jar
  curl -O http://www.congiu.net/hive-json-serde/1.3.7/hdp23/json-udf-1.3.7-jar-with-dependencies.jar
  cd ..
```
   spark
   >> <pyspark.sql.session.SparkSession object at 0x7ffb72e22d30>

   warehouseLocation = 'file://tmp/data/spark-warehouse'
   path = "file:///tmp/data/ol_cdump.json"
   spark = SparkSession.builder.appName('dojo').config('spark.sql.warehouse.dir', warehouseLocation).enableHiveSupport().getOrCreate()

   booksDF = spark.read.json(path)
   booksDF.printSchema()
   >> root
   >>   |-- alternate_names: array (nullable = true)
   >> note: poor shcema inferred

   booksDF.createOrReplaceTempView("old_books")
   booksDF.persist()
   results = spark.sql("select * title from old_books limit 1").collect()
   results
   results[0]
   results[0].created.value

   bookTitles = spark.sql("select distinct title from old_books ")
   bookTitles
   >> DataFrame[title: string]
   booksTitles.show(10, False)

   spark.sql("add jar /var/lib/spark-extras/json-serde-1.3.7-jar-with-dependencies.jar")
   spark.sql("add jar /var/lib/spark-extras/json-udf-1.3.7-jar-with-dependencies.jar")
   with open("/usr/spark-2.1.0/dojo/book-schema.sql") as fr:
     query = fr.read()
   results = spark.sql(query)
   booksTable = spark.sql("LOAD DATA LOCAL INPATH 'file:///tmp/data/ol_cdump.json' OVERWRITE INTO TABLE books")

   booksDF.write.format("parquet").mode("Append").partitionBy("created").parquet("/tmp/data/books.parquet")
   spark.sql("MSCK REPAIR TABLE books")

- Future reading

https://community.hortonworks.com/articles/82346/spark-pyspark-for-etl-to-join-text-files-with-data.html
http://cambridgespark.com/content/tutorials/interactively-analyse-100GB-of-JSON-data-with-Spark/index.html

        

