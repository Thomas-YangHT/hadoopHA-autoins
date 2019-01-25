source hadoop/CONFIG

[ $HOSTNAME = "nn1" ] &&  IP1=$NN1_IP && IP2=$NN2_IP && IP3=$DN1_IP
[ $HOSTNAME = "nn2" ] &&  IP1=$NN1_IP && IP2=$NN2_IP && IP3=$DN2_IP
[ $HOSTNAME = "dn1" ] &&  IP1=$NN1_IP && IP2=$DN1_IP && IP3=$NN2_IP
[ $HOSTNAME = "dn2" ] &&  IP1=$NN1_IP && IP2=$DN2_IP && IP3=$NN2_IP
[ $HOSTNAME = "dn3" ] &&  IP1=$NN1_IP && IP2=$DN3_IP && IP3=$NN2_IP

docker rm -f weavescope
$HOME/hadoop/scope launch -app.basicAuth  -probe.basicAuth -app.http.address  :4050 $IP1:4050 $IP2:4050 $IP3:4050
docker logs weavescope
