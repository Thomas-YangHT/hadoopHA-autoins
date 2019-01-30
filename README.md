# Auto Install Hadoop Cluster On Docker

##### 前言：

一个Hadoop自动安装脚本，以5台KVM虚拟机和docker为基础，来自动步署Hadoop集群（HDFS、YARN、HBASE、HIVE、SPARK、HUE、Jupyter-notebook、Scope等）

##### 各组件版本

HDFS 3.1.1

YARN 3.1.1

HBASE 2.1.1

HIVE 3.1.1

SPARK 2.4.0

HUE 4.3.0

Jupyter-notebook 4.4.0

Scope 1.10.1  

Mysql：mariadb 10.3.11

Solr: 7.6.0

Livy: 0.5.0

OOZIE:  5.0.0

Myweb:  自编，服务索引与服务状态监控



##### 架构与服务分配

| nn1                     | nn2                          | dn1         | dn2         | dn3         |
| ----------------------- | ---------------------------- | ----------- | ----------- | ----------- |
|                         |                              | zookeeper1  | zookeeper2  | zookeeper3  |
|                         |                              | JournalNode | JournalNode | JournalNode |
| NameNode                | NameNode                     | DataNode    | DataNode    | DataNode    |
| NodeManager             | NodeManager                  | NodeManager | NodeManager | NodeManager |
| ResourceManager         | ResourceManager              |             |             |             |
| HbaseMaster&Rest&Thrift | HiveMetadata&HiveServer2     | HbaseRegion | HbaseRegion | HbaseRegion |
|                         | SparkMaster                  | SparkWorker | SparkWorker | SparkWorker |
| YarnHistory&WebProxy    | SparkHistory&Livy&Solr&Oozie |             |             |             |
| Myweb                   | Hue&Mysql&Jupyter            |             |             |             |
| WeaveScope              | WeaveScope                   | WeaveScope  | WeaveScope  | WeaveScope  |

![1548824942881](C:\Users\qinghua\AppData\Roaming\Typora\typora-user-images\1548824942881.png)



##### 准备

- 克隆5台虚拟机，详见前篇**[基础架构十四：来试试把Centos7改造成Coreos]**，nn2需要调整到8G内存
- 下载所需docker镜相
  - [hadoopHa——.rar]()  包含9个安装用到的docker image, 解压到下一步clone的目录里
- 安装脚本工具  git clone  https://github.com/Thomas-YangHT/hadoopHA-autoins.git



##### 配置

`cd hadoopHa-autoins; vim CONFIG` #修改5台机器的IP

![1548825767739](C:\Users\qinghua\AppData\Roaming\Typora\typora-user-images\1548825767739.png)



##### 安装

`sh install all`  # 大约10分钟后完成安装

[![asciicast](https://asciinema.org/a/5xpUiRhrALXiustmQcALlWQ06.svg)](https://asciinema.org/a/5xpUiRhrALXiustmQcALlWQ06)

![1548826083534](C:\Users\qinghua\AppData\Roaming\Typora\typora-user-images\1548826083534.png)



##### 验证

打开安装完提示的链接：http://<your nn1 IP>

![1548826330694](C:\Users\qinghua\AppData\Roaming\Typora\typora-user-images\1548826330694.png)

##### 服务端口状态

![1548826388581](C:\Users\qinghua\AppData\Roaming\Typora\typora-user-images\1548826388581.png)



##### HDFS

![1548826426636](C:\Users\qinghua\AppData\Roaming\Typora\typora-user-images\1548826426636.png)



YARN

![1548826447366](C:\Users\qinghua\AppData\Roaming\Typora\typora-user-images\1548826447366.png)

HBASE

![1548826471071](C:\Users\qinghua\AppData\Roaming\Typora\typora-user-images\1548826471071.png)

SPARK

![1548826490838](C:\Users\qinghua\AppData\Roaming\Typora\typora-user-images\1548826490838.png)

HUE

![1548826621220](C:\Users\qinghua\AppData\Roaming\Typora\typora-user-images\1548826621220.png)

Solr

![1548826643309](C:\Users\qinghua\AppData\Roaming\Typora\typora-user-images\1548826643309.png)

Oozie

![1548826658381](C:\Users\qinghua\AppData\Roaming\Typora\typora-user-images\1548826658381.png)

Jupyter-notebook

![1548826686223](C:\Users\qinghua\AppData\Roaming\Typora\typora-user-images\1548826686223.png)

WeaveScope

![1548826723570](C:\Users\qinghua\AppData\Roaming\Typora\typora-user-images\1548826723570.png)



## [LinuxMan]：Linux 命令搜索与资料书籍

![Linux命令用法速查公众号，如：输入ls，返回用法链接，含500+命令用法](https://upload-images.jianshu.io/upload_images/12123313-21545308f7327a9b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```shell
  _       _                          __  __                 
 | |     (_)  _ __    _   _  __  __ |  \/  |   __ _   _ __  
 | |     | | | '_ \  | | | | \ \/ / | |\/| |  / _` | | '_ \ 
 | |___  | | | | | | | |_| |  >  <  | |  | | | (_| | | | | |
 |_____| |_| |_| |_|  \__,_| /_/\_\ |_|  |_|  \__,_| |_| |_|
```

