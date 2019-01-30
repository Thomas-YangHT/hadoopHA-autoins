source ./CONFIG
MYHOST=$NN2_IP

#    sql="update hostip  set ip=\"$NN1_IP\"  where hostname=\"nn1\" "
# (CASE WHEN ProgramId = "47545" THEN "Active" ELSE "Inactive" END)
sql="UPDATE hostip
    SET ip = (CASE hostname
        WHEN 'nn1' THEN '$NN1_IP'
        WHEN 'nn2' THEN '$NN2_IP'
        WHEN 'dn1' THEN '$DN1_IP'
        WHEN 'dn2' THEN '$DN2_IP'
        WHEN 'dn3' THEN '$DN3_IP'
    END)
WHERE hostname IN ('nn1','nn2','dn1','dn2','dn3')"
echo $sql|mysql -uyanght -D monitor -pyanght -h $MYHOST
sql="UPDATE monip_set
    SET ip = (CASE ip
        WHEN '192.168.253.44' THEN '$NN1_IP'
        WHEN '192.168.253.45' THEN '$NN2_IP'
        WHEN '192.168.253.46' THEN '$DN1_IP'
        WHEN '192.168.253.47' THEN '$DN2_IP'
        WHEN '192.168.253.48' THEN '$DN3_IP'
    END)"
echo $sql|mysql -uyanght -D monitor -pyanght -h $MYHOST
