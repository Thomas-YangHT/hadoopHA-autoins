docker run --name phphbase  \
--net host \
-v $PWD/nginx_download.conf:/etc/nginx/conf.d/nginx_download.conf \
-v $PWD/svc:/phphbaseadmin/svc \
-v $PWD/entrypoint.sh-phphbase:/entrypoint.sh \
-e TZ＝'Asia/Shanghai' \
--restart always \
-p 80:80 -p 443:443 \
-d phphbase
