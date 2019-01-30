source hadoop/CONFIG
cp hadoop/svc-hadoop.html hadoop/myweb/index.html

docker run --name myweb \
-v $PWD/hadoop/entrypoint.sh-myweb:/usr/bin/docker-entrypoint.sh \
-v $PWD/hadoop/myweb:/usr/share/myweb \
-p 80:80 \
--restart always \
--entrypoint /usr/bin/docker-entrypoint.sh \
-d myweb
