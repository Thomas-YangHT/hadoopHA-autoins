from fabric.api import *

def test():
    get('coreos-k8s/master-conf.tgz','master-conf.tgz')

def reset():
    with cd("$HOME/hadoop"):
        run("ls")

def prepare_images():
    put('hadoop-base-3.1.1.tgz', '')
    put('zookeeper.tgz', '')
    run('mkdir hadoop;tar zxvf hadoop-base-3.1.1.tgz -C hadoop')
    run('tar zxvf zookeeper.tgz -C hadoop')
    run('ls hadoop/*tar |awk \'{print "docker load <"$1}\'|sh')
    run('docker images')
    run('rm hadoop-base-3.1.1.tgz zookeeper.tgz')
    run('rm hadoop/*tar')

def prepare():
  #  run('export PATH=$PATH:/opt/bin')
  #  run('sudo kubeadm reset -f ')
    local('sh hosts_conf.sh')
    local('tar zcvf config.tgz docker*sh CONFIG *site.xml* workers hosts entrypoint.sh* st*.sh')
    put('config.tgz','')
    run('tar zxvf config.tgz -C hadoop')
    run('[ -f hosts.bak ] || cp /etc/hosts hosts.bak;cat hosts.bak hadoop/hosts >hosts.tmp;sudo cp hosts.tmp /etc/hosts')
    run('mkdir -p hadoop/data/logs/hadoop;mkdir -p hadoop/data/hadoop/hdfs/{nn,dn,jn};ls')

def zookeeper():
    run('docker rm -f zookeeper;docker ps')
    run('sh hadoop/docker-zookeeper.sh')
    run('docker exec zookeeper zkServer.sh status')
    
def journalnode():
    run('docker rm -f journalnode;docker ps')
    run('rm -rf hadoop/data/hadoop/hdfs/jn/*')
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
    run('docker rm -f namenode secondarynamenode resourcemanager;docker ps')
    run('sh hadoop/docker-secondarynamenode.sh')
    run('sh hadoop/docker-resourcemanager.sh')

def datanode():
    run('docker rm datanode -f;docker ps')
    run('sh hadoop/docker-datanode.sh')

def nodemanager():
    run('docker rm nodemanager -f;docker ps')
    run('sh hadoop/docker-nodemanager.sh')

def status():
    run('docker exec namenode hdfs haadmin -getServiceState nn1')
    run('docker exec namenode hdfs haadmin -getServiceState nn2')
    run('docker exec resourcemanager yarn rmadmin -getServiceState rm1')
    run('docker exec resourcemanager yarn rmadmin -getServiceState rm2')

def zstatus():
    run('docker exec zookeeper zkServer.sh status')

def finish():
    run('some cmd')

def cmd(str):
    run(str)    

def reboot():
    run('echo "reboot $HOSTNAME";sudo reboot;:')

def timezone8():
    run('sudo timedatectl set-timezone Asia/Shanghai')
    run('date')

def route():
    put('tools/route.sh','')
    run('sh route.sh')
