source ./hadoop/CONFIG
HBASE_CONF=/hbase/conf

#grep $DFS_NAMESERVERS /etc/hosts
#[ $? = 1 ] && sed -i "s/.*$NN1_IP.*/\0 $DFS_NAMESERVERS/g" /etc/hosts
docker run --name hregion \
--restart always \
--net host \
-v $PWD/hadoop/regionservers:$HBASE_CONF/regionservers \
-v $PWD/hadoop/hbase-site.xml:$HBASE_CONF/hbase-site.xml \
-v $PWD/hadoop/backup-masters:$HBASE_CONF/backup-masters \
-v $PWD/hadoop/entrypoint.sh-hregion:/entrypoint.sh \
-d harisekhon/hbase:2.1
