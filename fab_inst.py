from fabric.api import *
import commands

def test():
    get('coreos-k8s/master-conf.tgz','master-conf.tgz')

def prepare_images(IMG_NAME):
    run('mkdir hadoop;ls hadoop')
    (status,images) = commands.getstatusoutput('cat ' + IMG_NAME + '|sed "s/ //g"')
    #print images
    for image in images.split('\n') :
        print image
        put(image)
        run('tar zxvf ' + image + ' -C hadoop')
        #run('docker load -i hadoop/'+image.split('.')[0]+'*.tar')
        run('ls hadoop/*tar |awk \'{print "docker load <"$1}\'|sh')
        run('rm '+ image+' hadoop/*tar')
    run('docker images|grep -P "none.*none"|awk \'{print $3}\'|xargs docker rmi;pwd')
    run('docker images')

def prepare():
    local('sh hosts_conf.sh')
    #local('source ./CONFIG;sed  "s/NN1_IP/$NN1_IP/g" nginx_download.conf.template >nginx_download.conf')
    local('source ./CONFIG; \
sed -i "s/server_name.*localhost/server_name    $NN1_IP/g" myweb/nginx_download.conf  && \
sed -i "s/MysqlHost=\\\".*\\\"/MysqlHost=\\\"$NN2_IP\\\"/g" myweb/qinconfig.inc.php && \
sed -i "s/MYHOST=\".*\"/MYHOST=\"$NN2_IP\"/g" myweb/portcheck.sh')
    local('cat CONFIG_FILES|grep -vP "^#|^$" |xargs tar zcvf config.tgz')
    #local('tar zcvf config.tgz docker*sh CONFIG *site.xml* workers hosts entrypoint.sh* st*.sh regionservers backup-masters slaves spark-env.sh spark-defaults.conf nginx_download.conf')
    put('config.tgz','')
    run('tar zxvf config.tgz -C hadoop')
    run('[ -f hosts.bak ] || cp /etc/hosts hosts.bak;cat hosts.bak hadoop/hosts >hosts.tmp;sudo cp hosts.tmp /etc/hosts')
    run('[ -f .bashrc.bak ] || cp .bashrc .bashrc.bak;cat .bashrc.bak >.bashrc;echo \'export PS1="\[\e[36;40m\]\u@\h\[\e[33;40m\]\\t\[\e[0m\]\w#"\'>>.bashrc')
    run('source hadoop/CONFIG;mkdir -p $HADOOP_DATA_DIR/logs/hadoop;mkdir -p $HADOOP_DATA_DIR/hadoop/hdfs/{nn,dn,jn};ls')

def prepare_mysql():
    put('mysql.tgz','')
    run('tar zxvf mysql.tgz -C hadoop')

def reset():
    run('docker ps -q|xargs docker rm -f ')
    run('source hadoop/CONFIG;rm -rf $HADOOP_DATA_DIR;')

def zookeeper():
    run('docker rm -f zookeeper;docker ps')
    run('sh hadoop/docker-zookeeper.sh')
    run('sleep 10;docker exec zookeeper zkServer.sh status')
    
def journalnode():
    run('docker rm -f journalnode;docker ps')
    run('source hadoop/CONFIG;rm -rf $HADOOP_DATA_DIR/hadoop/hdfs/jn/*')
    run('sh hadoop/docker-journalnode.sh')

def format():
    run('sh hadoop/docker-format.sh')

def startnn1():
    run('docker rm -f namenode resourcemanager;docker ps')
    run('sh hadoop/docker-namenode.sh')
    run('sh hadoop/docker-resourcemanager.sh')

def standby():
    run('sh hadoop/docker-standby.sh')

def startnn2():
    run('docker rm -f namenode resourcemanager;docker ps')
    run('sh hadoop/docker-namenode.sh')
    run('sh hadoop/docker-resourcemanager.sh')

def datanode():
    run('docker rm datanode -f;docker ps')
    run('sh hadoop/docker-datanode.sh')

def nodemanager():
    run('docker rm nodemanager -f;docker ps')
    run('sh hadoop/docker-nodemanager.sh')

#HBASE
def hmaster():
    run('docker rm hmaster -f;docker ps')
    run('sh hadoop/docker-hmaster.sh')

def hregion():
    run('docker rm hregion -f;docker ps')
    run('sh hadoop/docker-hregion.sh')

#Spark master
def spark():
    run('docker rm spark -f;docker ps')
    run('sh hadoop/docker-spark.sh')

def sparkslave():
    run('docker rm sparkslave -f;docker ps')
    run('sh hadoop/docker-sparkslave.sh')

def hue():
    run('docker rm hue -f;docker ps')
    run('sh hadoop/docker-hue.sh')

def mysql():
    run('docker rm mariadb -f;docker ps')
    run('sh hadoop/docker-mysql.sh')

def hive():
    run('docker rm hive -f;docker ps')
    run('sh hadoop/docker-hive.sh')

def hiveinit():
    run('docker exec spark hadoop dfs -mkdir -p /user/hive/warehouse')
    run('docker exec spark hadoop dfs -chmod g+w /user/hive/warehouse')
    run('docker exec spark schematool -dbType mysql -initSchema')

def oozie():
    run('docker rm oozie -f;docker ps')
    run('sh hadoop/docker-oozie.sh')

def oozieinit():
    run('sh hadoop/oozie-init.sh')

def myweb():
    put('svc-hadoop.html','hadoop/svc-hadoop.html')
    run('docker rm myweb -f;docker ps')
    run('sh hadoop/docker-myweb.sh')

def nginx():
    put('svc-hadoop.html','hadoop/svc-hadoop.html')
    run('docker rm nginx -f;docker ps')
    run('sh hadoop/docker-nginx.sh')

def scope():
    run('sh hadoop/scope-launch.sh')

def status():
    run('echo "NN1 status:";docker exec namenode hdfs haadmin -getServiceState nn1')
    run('echo "RM1 status:";docker exec resourcemanager yarn rmadmin -getServiceState rm1')

def status2():
    run('echo "NN2 status:";docker exec namenode hdfs haadmin -getServiceState nn2')
    run('echo "RM2 status:";docker exec resourcemanager yarn rmadmin -getServiceState rm2')

def zstatus():
    run('docker exec zookeeper zkServer.sh status')

def jupyterweb():
    run('docker exec spark jupyter-notebook list|grep http')

def finish():
    run('some cmd')

def stopjn():
    run('docker exec journalnode hdfs --daemon stop journalnode')

def stopdn():
    run('docker exec datanode hdfs --daemon stop datanode')

def stopnn():
    run('docker exec namenode hdfs --daemon stop namenode')
    run('docker exec namenode hdfs --daemon stop zkfc')
    run('docker exec namenode hdfs --daemon stop nfs3')
    run('docker exec namenode hdfs --daemon stop portmap')

def stopnm():
    run('docker exec nodemanager yarn --daemon stop nodemanager')

def stoprm():
    run('docker exec resourcemanager yarn --daemon stop resourcemanager')
    
def stophmaster():
    run('docker exec hmaster hbase master stop')
    
def stophregion():
    run('docker exec hregion hbase regionserver stop')
    
def startjn():
    run('docker exec journalnode hdfs --daemon start journalnode')

def startdn():
    run('docker exec datanode hdfs --daemon start datanode')

def startnn():
    run('docker exec namenode hdfs --daemon start namenode')
    run('docker exec namenode hdfs --daemon start zkfc')
    run('docker exec namenode hdfs --daemon start portmap')
    run('docker exec namenode hdfs --daemon start nfs3')

def startnm():
    run('docker exec nodemanager yarn --daemon start nodemanager')

def startrm():
    run('docker exec resourcemanager yarn --daemon start resourcemanager')
    
def starthmaster():
    run('docker exec hmaster hbase master start')
    
def starthregion():
    run('docker exec hregion hbase regionserver start')
    
def cmd(str):
    run(str)    

def putfile(str):
    put(str)    

def getfile(str):
    get(str)    

def reboot():
    run('echo "reboot $HOSTNAME";sudo reboot;:')

def timezone8():
    run('sudo timedatectl set-timezone Asia/Shanghai')
    run('date')

def route():
    put('tools/route.sh','')
    run('sh route.sh')
