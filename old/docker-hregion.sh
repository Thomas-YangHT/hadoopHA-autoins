source ./hadoop/CONFIG
grep $DFS_NAMESERVERS /etc/hosts
[ $? = 1 ] && sed -i "s/.*$NN1_IP.*/\0 $DFS_NAMESERVERS/g" /etc/hosts
docker run --name hregion \
--restart always \
--net host \
-v $PWD/hadoop/regionservers:/etc/hbase/regionservers \
-v $PWD/hadoop/hbase-site.xml:/etc/hbase/hbase-site.xml \
-v $PWD/hadoop/entrypoint.sh-hregion:/entrypoint.sh \
-d bde2020/hbase-base
