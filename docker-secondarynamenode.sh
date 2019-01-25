source ./hadoop/CONFIG
docker run --name namenode \
--restart always \
--net host \
-v $PWD/hadoop/core-site.xml:/etc/hadoop/core-site.xml \
-v $PWD/hadoop/hdfs-site.xml:/etc/hadoop/hdfs-site.xml \
-v $PWD/hadoop/mapred-site.xml:/etc/hadoop/mapred-site.xml \
-v $PWD/hadoop/yarn-site.xml:/etc/hadoop/yarn-site.xml \
-v $PWD/hadoop/workers:/etc/hadoop/workers \
-v $PWD/hadoop/entrypoint.sh-secondarynamenode:/entrypoint.sh \
-v $HADOOP_DATA_DIR:/opt/data \
-v $PWD/hadoop/start-dfs.sh:/opt/hadoop-3.1.1/sbin/start-dfs.sh \
-v $PWD/hadoop/stop-dfs.sh:/opt/hadoop-3.1.1/sbin/stop-dfs.sh \
-v $PWD/hadoop/start-yarn.sh:/opt/hadoop-3.1.1/sbin/start-yarn.sh \
-v $PWD/hadoop/stop-yarn.sh:/opt/hadoop-3.1.1/sbin/stop-yarn.sh \
-d bde2020/hadoop-base:2.0.0-hadoop3.1.1-java8 
