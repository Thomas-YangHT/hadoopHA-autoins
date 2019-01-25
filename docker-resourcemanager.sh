source ./hadoop/CONFIG
docker run --name resourcemanager \
--restart always \
--net host \
-v $PWD/hadoop/core-site.xml:/etc/hadoop/core-site.xml \
-v $PWD/hadoop/hdfs-site.xml:/etc/hadoop/hdfs-site.xml \
-v $PWD/hadoop/mapred-site.xml:/etc/hadoop/mapred-site.xml \
-v $PWD/hadoop/yarn-site.xml:/etc/hadoop/yarn-site.xml \
-v $PWD/hadoop/workers:/etc/hadoop/workers \
-v $PWD/hadoop/entrypoint.sh-resourcemanager:/entrypoint.sh \
-v $HADOOP_DATA_DIR:/opt/data \
-d bde2020/hadoop-base:2.0.0-hadoop3.1.1-java8 
