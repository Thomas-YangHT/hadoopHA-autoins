source ./hadoop/CONFIG
HBASE_CONF=/hbase/conf

#grep $DFS_NAMESERVERS /etc/hosts
#[ $? = 1 ] && sed -i "s/.*$HOSTNAME.*/\0 $DFS_NAMESERVERS/g" /etc/hosts
docker run --name hmaster \
--restart always \
--net host \
-v $PWD/hadoop/regionservers:$HBASE_CONF/regionservers \
-v $PWD/hadoop/hbase-site.xml:$HBASE_CONF/hbase-site.xml \
-v $PWD/hadoop/backup-masters:$HBASE_CONF/backup-masters \
-v $PWD/hadoop/entrypoint.sh-hmaster:/entrypoint.sh \
-d harisekhon/hbase:2.1

#-d bde2020/hbase-base
