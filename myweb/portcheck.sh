#!/usr/bin/bash
#
#portcheck.sh: Read settings from DB,then use nmap to check ports open/close status;
#
#多端口多IP的方式执行：
#nmap -sT -p 80,8080,3306,22,443,8090,2201,8081,8082,8093,8014,2181 -n -Pn 192.168.31.222 192.168.200.1 192.168.200.3 119.254.187.192 192.168.100.222>check1.log

#读取数据存入checkport.set，分解成monports.csv和monips.csv
func_GETDATA(){
    MYHOST="192.168.100.222"
    sql="select \* from monip_set inner join monport_set where monip_set.id=monport_set.id"
    echo $sql|sed 's/\\//'|mysql -uyanght -D monitor -pyanght -h $MYHOST|tr '\t' ','|sed -n '2,$ p'|sort -t, -k 3 >checkport.set
    cat checkport.set |awk -F, '{print $4","$5","$6","$7}'|uniq >monports.csv
    #$3是ID，$1是IP
    cat checkport.set |awk -F, '{ips[$3]=$1" "ips[$3];id[$3]=$3;}\
    END{ \
      for(i=1;i<=length(id);i++){ \
         print id[i]","ips[id[i]];\
    }}'>monips.csv
}

#生成nmap命令参数并执行，结果存入check<ID>.log
func_NMAP(){
    awk -F, 'NR==FNR{a[$1]=$3}NR>FNR{gsub(" ",",",a[$1]);print "nmap -sT -n -Pn -p ",a[$1],$2">check"$1".log"}' monports.csv monips.csv|sh
}
   
#处理nmap输出,按ID分组转成csv格式check<ID>.csv
func_CHKLOG(){
    more $FILE.log|grep -Ev "Host|PORT|done"|awk 'BEGIN{i=0}{
      if(/Starting/){ checkdate=$8" "$9":00" } 
      else if(/Nmap scan/){ i++;ips[i]=$5; }
      else{ gsub("/tcp","",$1);
	       port[ips[i]]=port[ips[i]]$1" ";
           if($2=="open") checkresult[ips[i]]=checkresult[ips[i]]"1";
           else if($2=="closed") checkresult[ips[i]]=checkresult[ips[i]]"0";
           else if($2=="filtered") checkresult[ips[i]]=checkresult[ips[i]]"2";
      }
    }END{
      for(j=1;j<=i;j++){
         print checkdate","ips[j]","checkresult[ips[j]]","port[ips[j]]
      }
    }' >$FILE.csv
}

#存入数据库portstatusinfo表
func_SAVETODB(){
  sql1="LOAD DATA LOCAL INFILE '$FILE.csv'  INTO TABLE portstatusinfo CHARACTER SET utf8  FIELDS TERMINATED BY ',' (time, ip,portstatus);"
  echo $sql1|mysql -uyanght -D monitor -pyanght -h $MYHOST
}

#分组比对配置，生成可读性强的页面
func_CHKCSV(){
    #先输出table的表头信息，包括时间、IP、端口号列表
    more monports.csv |awk -F, -v n=$1 '$1==n{p=$2;split(p,a," ");printf "time,ip,";len=length(a);for(i=1;i<=len;i++){if(i<len){printf a[i]",";}else{print a[i]""}}}' >$FILE.result
    #NR==FNR时，$1时间、$2是IP、$3是结果存入b，$4是结果的端口列表（无序）存入e
	#NR>FNR时，$1是IP，$2设定是否检查的列表存入C，$6是设定的端口号列表存入d
    awk -F, -v n=$1 'NR==FNR{a[$2]=$1","$2;b[$2]=$3;e[$2]=$4;}NR>FNR{if($3==n){c[$1]=$2;d[$1]=$6}} \
    END{
    for(ip in a){
        printf a[ip]",";
		split(e[ip],ee," ");
		split(d[ip],dd," ");
		len=length(ee);
		for(k=1;k<=len;k++){
		   f[ee[k]]=substr(b[ip],k,1);
		}
        len=length(c[ip]);
        for(i=1;i<=len;i++){
            ck=substr(c[ip],i,1);
            if(ck==1){
                if(f[dd[i]]==1){printf "S"}
                else{printf "E"}
            }else{printf "N"}
            if(i<len){printf ","}
            else{print ""}
        } 
    }
    }' $FILE.csv checkport.set >>$FILE.result
	sh csvtohtml2.sh $FILE.result>>check.html
}

#id为分组信息，按分组循环进行分析和入库
func_CHECK(){
    id=(`more checkport.set|awk -F, '{print $3}'|uniq`)
    len=${#id[@]}
	str1="<TABLE  WIDTH='100%'  >"
    str2="<TR><TD align=center COLSPAN=15 BGCOLOR=#ffffff> <FONT SIZE=5><B> 服务器端口状态 </B> </FONT><p align=right >`date "+%Y-%m-%d %H:%M:%S"`</p></TD></TR>"; 
	echo $str1 $str2>check.html
    for((i=0;i<$len;i++))
    do
       FILE=`echo "check"${id[$i]}`
       echo $FILE
       func_CHKLOG
       func_SAVETODB
	   func_CHKCSV ${id[$i]}
    done
}

#-----------
func_GETDATA
func_NMAP
func_CHECK
