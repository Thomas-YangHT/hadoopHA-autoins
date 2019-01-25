source ./hadoop/CONFIG
SPARK_HOME=/spark-2.4.0

docker run --name sparkslave \
--restart always \
--net host \
-v $PWD/hadoop/spark-env.sh:$SPARK_HOME/conf/spark-env.sh \
-v $PWD/hadoop/spark-defaults.conf:$SPARK_HOME/conf/spark-defaults.conf \
-v $PWD/hadoop/slaves:$SPARK_HOME/conf/slaves \
-v $PWD/hadoop/core-site.xml:/etc/hadoop/core-site.xml \
-v $PWD/hadoop/hdfs-site.xml:/etc/hadoop/hdfs-site.xml \
-v $PWD/hadoop/mapred-site.xml:/etc/hadoop/mapred-site.xml \
-v $PWD/hadoop/yarn-site.xml:/etc/hadoop/yarn-site.xml \
-v $PWD/hadoop/workers:/etc/hadoop/workers \
-v $PWD/hadoop/entrypoint.sh-sparkslave:/entrypoint.sh \
-d spark:2.4.0

