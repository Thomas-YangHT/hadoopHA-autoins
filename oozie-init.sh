docker exec oozie /oozie-5.0.0/bin/oozie-setup.sh
docker exec oozie /oozie-5.0.0/bin/ooziedb.sh create -sqlfile oozie.sql -run
docker exec oozie /oozie-5.0.0/bin/oozie-setup.sh sharelib create -fs hdfs://mycluster:8020 -locallib oozie-sharelib-5.0.0.tar.gz
docker restart oozie
