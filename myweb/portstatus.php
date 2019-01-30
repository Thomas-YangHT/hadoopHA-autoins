<?php 
//PHP 服务器端口状态监控程序
//Modified by Thomas Yang 168447636@qq.com
//只显示端口连接状态，不存入数据库和文件
//参考：http://phorum.vbird.org/viewtopic.php?f=1&t=17573
//将原文HOST文件设置改为数据库表中设置，增加支持分组测试

//从数据库取得设置数据：
//portstatussetting表设置所要监控的IP、对应的端口是否监控、所属分组ID，
//如192.168.100.25,00000111100,1 表示IP为192.168.100.25主机在第一分组，0表示对应位的端口不监控，1表示监控；
//monports表设置所要监控的分组ID号、端口名、端口号、UDP/TCP
//如：1，http https mysql 8090 2201ssh 8080 8081 8082 8093 8014 2181，80 443 3306 8090 2201 8080 8081 8082 8093 8014 2181，TTTTTTTTTTT
//表示第一分组，要测试的端口名依次是http https...等共11个，端口号依次是80 443...等数量同前，T代表TCP，U代表UDP，表对应位上端口的协议
function GetSetData(){
	global $tabs;
	global $portnamess;
	global $portss;
	global $gets;
	global $protocolss;
	global $remarks;
	
    //请根据需要修改mysql相关设置
	include_once("qinconfig.inc.php");
	$conn=mysql_connect($MysqlHost,$MysqlUser,$MysqlPass)	or die("无法连接数据库，请重来");
	mysql_select_db($mondb,$conn);
	mysql_query("SET NAMES UTF8");
    
    //取得ID数量，即表格分组数量；
    $sql="select count(distinct id) from monitor.monip_set";
    $res=mysql_query($sql,$conn);
    $row=mysql_fetch_array($res);
    $tabs=$row[0];
    //echo "tabs:".$tabs;
    
    $sql1="select b.hostname,a.ip,a.monif,a.id from monitor.monip_set as a  inner join hostip as b on trim(a.ip)=trim(b.ip) where b.`status`!='close' order by id,hostname;";       
    $res1=mysql_query($sql1,$conn);
    $rows1=mysql_affected_rows($conn);//获取行数
    $colums1=mysql_num_fields($res1);//获取列数
    while($row=mysql_fetch_array($res1))  {
       for($i=0;$i<$tabs;$i++){
    	   if ($row['id']==$i+1){  $gets[$i][]=$row; }
       }
    }
    
    $sql2="select id,portsnames,ports,protocols,remark from monitor.monport_set order by id;";
    $res2=mysql_query($sql2,$conn);
    $rows2=mysql_affected_rows($conn);//获取行数
    $colums2=mysql_num_fields($res2);//获取列数
    
    while($row2=mysql_fetch_array($res2)){
       for($i=0;$i<$tabs;$i++){
    	   if ($row2['id']==$i+1){  
    			$portnamess[$i]=split(" ",$row2['portsnames']);
    			$portss[$i]=split(" ",$row2['ports']); 
    			$protocolss[$i]=$row2['protocols'];
				$remarks[$i]=$row2['remark'];
    	   }
       }	
    }
}

//参数为：端口名称，端口号，包含主机IP和是否监测的配置两维数组：$get[$i][0]为IP，$get[$i][1]为主机名,$get_line[$i][2]为端口是否监测的配置
function table($portnames,$port,$get,$protocols,$remark){
	#echo "<TABLE BORDER=10 WIDTH='100%'  BGCOLOR=#00ff00>"; 
	echo "<TABLE  BORDER=1 WIDTH='100%' >"; 
    //顯示標題 
	echo "<TR BGCOLOR=#ccddee><TH>".$remark."</TH><TH>IP</TH><TH>侦测时间</TH>";
	#显示端口名称的表头<TH>http</TH><TH>https</TH><TH>mysql</TH><TH>8090</TH><TH>2201ssh</TH><TH>8080</TH><TH>8081</TH><TH>8082</TH><TH>8093</TH><TH>8014</TH><TH>2181</TH>
	$portnum=count($portnames);
	for($i=0; $i < $portnum; $i++){
		echo "<TH>$portnames[$i]</TH>";
	}
	echo "</TR>";
	 
//取得測試主機數量,計算 $get 陣列的元素數目即可得知 
	$host_count = count($get); 	 
	//存放测试结果，以便存入数据库：$testresult[$i][0]为IP，$testresult[$i][1]为日期，$testresult[$i][2]为结果
	$testresult = array();

	for ( $i = 0 ; $i < $host_count ; $i++ ) { 
//切割每一列的資料存入陣列,以 @ 為分割符號, $get_line[$i][0] 為主機名稱 , $get_line[$i][1] 為測試的 IP 或主機名稱 
//$get_line[$i][2] 為測試項目,共有 N 項 
		$get_line[$i]=$get[$i];
//顯示欄位名稱 
		date_default_timezone_set("PRC");
		#BGCOLOR=#62defe  BGCOLOR=#77ff00
		echo "<TR><TD  WIDTH=20%>" . $get_line[$i][0] ."</TD><TD WIDTH=8%> ". $get_line[$i][1] . "</TD><TD ALIGN=CENTER WIDTH=6%>" . date("H:i:s",time()) . "</TD>"; 
//取得測試項目的長度,並去除頭尾的空白字元 
		$testresult[$i][0] = $get_line[$i][1];
		$testresult[$i][1] = date("H:i:s",time());
		$len = strlen(trim($get_line[$i][2])); 
//測試 timeout 時間 
		$timeout = 5; 
		for ( $j = 0 ; $j < $len ; $j++) { 
	//各別取出比對項目每一項的值,若等於 1 ,就做測試 , 0 測不做測試 
			if (substr($get_line[$i][2],$j,1) == "1") { 
	//進行測試,並抑制錯誤訊息輸出 
				//$test[$j] = @fsockopen($get_line[$i][1],$port[$j],$errno,$errstr,$timeout); 
				//使用stream_socket_client代替@fsockopen以支持UDP；
				if (substr($protocols,$j,1)=='T') {$protocol="tcp";}
				else{$protocol="udp";}
				$test[$j] = stream_socket_client("{$protocol}://{$get_line[$i][1]}:{$port[$j]}", $errno, $errstr,$timeout); 
	//顯示測試結果 
				if ($test[$j]) { 
					echo "<TD BGCOLOR=yellow align=center>成功</FONT></TD>"; 
					$testresult[$i][2] .= "1"; 
				} else { 
					echo "<TD BGCOLOR=red align=center><FONT COLOR=white>失败</FONT></TD>"; 
					$testresult[$i][2] .= "0"; 
				} 
			} else { 
			    #BGCOLOR=#fed19a
				echo "<TD  align=center><FONT COLOR=blue> N/A </FONT></TD>"; 
				$testresult[$i][2] .= "2"; 
			} 
		} 
		echo "</TR>"; 
	} 
	echo "</TABLE>"; 
}


//設定更新時間 
header("Refresh:600"); 
//標題 
$title = "  服务器状态监控"; 
//取得現在的日期時間,並轉換成 'YYYY 年 M 月 D 日' 的格式 
date_default_timezone_set("PRC");
$date = date("Y 年 m 月 j 日 H:i:s",time()); 
//取得今天的星期, 0 為 '星期天' , 1 為 '星期一' , ... , 6 為 '星期六' 
$week = date("w",time()); 
//陣列查表,將數字的星期,轉換成中文 
$weekday = array('星期日','星期一','星期二','星期三','星期四','星期五','星期六'); 
//顯示表格 BORDER=10 BGCOLOR=#00ff00
echo "<TABLE  WIDTH='100%'  >"; 
//顯示標題 
echo "<TR><TD align=center COLSPAN=15 BGCOLOR=#ffffff> <FONT SIZE=5><B> $title </B> </FONT><p align=right >$date " . $weekday[$week] . "</p></TD></TR>"; 
//取得设置数据
GetSetData();

//按照分组来测试并显示檢測項目
for($i=0;$i<$tabs;$i++){
	table($portnamess[$i],$portss[$i],$gets[$i],$protocolss[$i],$remarks[$i]);
}

//備註 BORDER=10 BGCOLOR=#00ff00
echo "<TABLE  WIDTH='100%'  >"; 
$message = "<B>备注：</B><BR>　　1.N/A 表示未测试 <BR>　　2.本页面10分钟更新一次"; 
echo "<TR><TD COLSPAN=15 BGCOLOR=#ffffff> $message </TD><TR>"; 
echo "</TABLE>"; 
?>
