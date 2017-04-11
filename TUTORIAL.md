Spark Dojo
=========


1. clone do repositorio e cd spark-dojo
2. baixar dados de exemplo
   curl -o ./data/ol_cdump.json  https://s3-eu-west-1.amazonaws.com/csparkdata/ol_cdump.json
3. iniciar o cluster
   docker-compose up -d
4. acessar o cluster em puspark shell
   docker exec -it dockerspark_master_1 bin/pyspark
   docker exec -it dockerspark_master_1 /bin/bash
5. após entrar no shell executar os comandos
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

 6. seguir demais exemplos de http://cambridgespark.com/content/tutorials/interactively-analyse-100GB-of-JSON-data-with-Spark/index.html