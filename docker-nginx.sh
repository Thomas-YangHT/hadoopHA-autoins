docker run --name nginx  \
-v $PWD/hadoop/nginx_download.conf:/etc/nginx/conf.d/nginx_download.conf \
-v $PWD/hadoop/svc-hadoop.html:/usr/share/nginx/html/index.html \
-e TZ＝'Asia/Shanghai' \
--restart always \
-p 80:80 -p 443:443 \
-d nginx
