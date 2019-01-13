source ./hadoop/CONFIG

[ $HOSTNAME = "`echo $DN1_HOSTNAME |grep -Po $HOSTNAME`" ] &&  ID=1  && DN1_IP=0.0.0.0 
[ $HOSTNAME = "`echo $DN2_HOSTNAME |grep -Po $HOSTNAME`" ] &&  ID=2  && DN2_IP=0.0.0.0 
[ $HOSTNAME = "`echo $DN3_HOSTNAME |grep -Po $HOSTNAME`" ] &&  ID=3  && DN3_IP=0.0.0.0

SERVERS="server.1=$DN1_IP:2888:3888 server.2=$DN2_IP:2888:3888 server.3=$DN3_IP:2888:3888"

docker run --name zookeeper \
--restart always \
-e ZOO_MY_ID=$ID \
-e ZOO_SERVERS="$SERVERS" \
-p 2181:2181 \
-p 2888:2888 \
-p 3888:3888 \
-d zookeeper

