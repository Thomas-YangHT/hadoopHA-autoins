#!/usr/bin/bash
#
#Script for install k8s1.12.1 HA on CoreOS by LinuxMan
#  _       _                          __  __                 
# | |     (_)  _ __    _   _  __  __ |  \/  |   __ _   _ __  
# | |     | | | '_ \  | | | | \ \/ / | |\/| |  / _` | | '_ \ 
# | |___  | | | | | | | |_| |  >  <  | |  | | | (_| | | | | |
# |_____| |_| |_| |_|  \__,_| /_/\_\ |_|  |_|  \__,_| |_| |_|
#                                                             
#

#start timestamp
D1=`date +%s`

#if no fab cmd, then install fabric
which fab;[ $? -eq 1 ] && echo "install fabric" && yum install -y fabric 
#or: pip install fabric==1.14.0

#import config
[ -n "$2" ] && ([ "$2" = "-c" ] || [ "$2" = "--config" ]) && [ -f $3 ] && echo "use config file:$3" && source ./$3 \
|| echo "use default configfile" && source ./CONFIG
#import FUNC
source ./FUNCTION
#
case $1 in
p0|pimages)
  echo "start prepare images ..."
  func_images_prepare
;;
p|pconfig)
  echo "start prepare config..."
  func_config_prepare
;;
zookeeper)
  echo "start zookeeper..."
  func_zookeeper
;;
journalnode)
  echo "start journalnode..."
  func_journalnode
;;
format)
  echo "start format..."
  func_format
;;
startnn1)
  echo "start nn1..."
  func_startnn1
;;
standby)
  echo "start standby..."
  func_standby
;;
startnn2)
  echo "start nn2..."
  func_startnn2
;;
datanode)
  echo "start datanode..."
  func_datanode
;;
nodemanager)
  echo "start nodemanager..."
  func_nodemanager
;;
reset)
  echo "reset"
  func_reset
;;
finish)
  echo "services message:"
  func_finish
;;
reboot)
  echo "reboot:"
  func_reboot
;;
genindex)
  echo "gen index svc-hadoop.html:"
  func_genindex
;;
timezone8)
  echo "timezone8:"
  func_timezone8
;;
route)
  echo "route:"
  func_route
;;
cmd)
  echo "cmd:$2"
  cmdstr=$2
  func_cmd
;;
status)
  echo "cluster status:"
  func_status
;;
default|all)
  echo "start all install..."
  func_images_prepare
  func_config_prepare
  func_zookeeper
  func_journalnode
  func_format
  func_startnn1
  func_standby
  func_startnn2
  func_datanode
  func_nodemanager
  func_status
  func_genindex
  func_finish
;;
help|*)
  echo "usage: $0 [p0|pimages|p|pconfig|zookeeper|journalnode|format|startnn1|standby|startnn2|datanode|nodemanager|status|finish|all|default|help|...   [-c|--config  /path/to/config/config.filename]"
  echo -e "\
        p0|pimages     :cp&load all tgz&images to all nodes.\n\
        p|pconfig      :cp config&shell to all nodes.\n\
        zookeeper      :install zookeeper cluster on ZKX\n\
        journalnode    :install JN on JNX\n\
        format         :format ZKFC&Nodename on nn1\n\
        startnn1       :start NN/ZKFC/RM on nn1\n\
        standby        :sync namenode info on nn2\n\
        startnn2       :start NN/ZKFC/RM on nn2\n\
        datanode       :start datanode on DNX\n\
        nodemanager    :start nodemanager on all nodes\n\
        status         :get status of NameNode&ResourceManager(NN&RM) & zookeeper\n\
        timezone8      :set timezone CST-8\n\
        route          :add route temporally\n\
  "
;;
esac

#cost seconds
D2=`date +%s`
echo ALL Mission completed in $((D2-D1)) seconds

#END.
