#!/bin/bash
Master2Position=$(mysql "-u$MYSQL_REPLICA_USER" "-p$MYSQL_REPLICA_PASS" "-hmaster2" -e "show master status\G" | awk '/Position/ {print $2}' 2>/dev/null )

Master2File=$(mysql "-u$MYSQL_REPLICA_USER" "-p$MYSQL_REPLICA_PASS" "-hmaster2" -e "show master status\G" | awk '/File/ {print $2}' 2>/dev/null )

MYSQL1=$(mysql "-u$MYSQL_REPLICA_USER" "-p$MYSQL_REPLICA_PASS" "-hlocalhost" -e "show slave status\G" 2>/dev/null ) 

MYSQL2=$(mysql "-uroot" "-p$MYSQL_ROOT_PASSWORD" "-hlocalhost" -e "CHANGE MASTER TO MASTER_HOST='master2', MASTER_PORT=$MYSQL_MASTER_PORT, MASTER_USER='$MYSQL_REPLICA_USER', MASTER_PASSWORD='$MYSQL_REPLICA_PASS', MASTER_LOG_FILE='$Master2File', MASTER_LOG_POS=$Master2Position;" 2>/dev/null  )

MYSQL3=$(mysql "-uroot" "-p$MYSQL_ROOT_PASSWORD" "-hlocalhost" -e "START SLAVE;" 2>/dev/null )

if [ ! "$MYSQL1" ]
        then
                echo "the docker container is mysql master"
                $MYSQL2 2>/dev/null 
                if [ $? -ne 0 ];then echo "ERROR: configure failed !"
				     exit
				else echo "configure success";fi
                $MYSQL3 2>/dev/null
                if [ $? -ne 0 ];then echo "ERROR: start slave failed !"
			   	     exit
				else echo "start success";fi
fi
