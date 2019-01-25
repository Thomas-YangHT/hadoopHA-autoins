export SPARK_MASTER_IP=nn2
export SPARK_WORKER_MEMORY=1024m
export SCALA_HOME=/scala-2.12.8
#export SPARK_HOME=/spark-2.4.0-bin-without-hadoop-scala-2.12
export SPARK_HOME=/spark-2.4.0
export SPARK_LIBRARY_PATH=$SPARK_HOME/lib
export SCALA_LIBRARY_PATH=$SPARK_LIBRARY_PATH
export SPARK_WORKER_CORES=1
export SPARK_WORKER_INSTANCES=1
export SPARK_MASTER_PORT=7077
export HADOOP_CONF_DIR=/etc/hadoop
export YARN_CONF_DIR=/etc/hadoop
export HIVE_HOME=/apache-hive-3.1.1
export SPARK_DIST_CLASSPATH=$(hadoop classpath)
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

