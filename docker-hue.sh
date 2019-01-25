docker run --name hue \
--restart always \
--net host \
-v $PWD/hadoop/core-site.xml:/hue/desktop/conf/core-site.xml \
-v $PWD/hadoop/hdfs-site.xml:/hue/desktop/conf/hdfs-site.xml \
-v $PWD/hadoop/mapred-site.xml:/hue/desktop/conf/mapred-site.xml \
-v $PWD/hadoop/yarn-site.xml:/hue/desktop/conf/yarn-site.xml \
-v $PWD/hadoop/hue.ini:/hue/desktop/conf/hue.ini \
-d gethue/hue:latest
