#If ClickHouse server has running queries lower than 100, it returns an error email.
#linkedin : https://www.linkedin.com/in/can-sayın-b332a157/
#cansayin.com

#!/bin/bash
 
cd /home/clickhouse
clickhouse-client -q "SELECT case when value < 100 then '404' else 'not alarm' end FROM system.metrics where metric = 'Query' limit 1" >> clickhouseQueryAlert.txt
 
cd /home/clickhouse
host = hostname
usep= cat clickhouseQueryAlert.txt
if [ "${usep}" -gt 1 ]; then
echo "There is low number query is running on $host" > /tmp/clickhouseQueryAlert.out

 
tomail='can.sayn@chistadata.com'
frommail='can.sayn@chistadata.com'
smtpmail=smtp.chistadata.com
echo "There is low number query is running on $host"  | /bin/mailx -s "$host Clickhouse Query Error" -r  "$frommail" -S smtp="$smtpmail" $tomail < /tmp/clickhouseQueryAlert.out
 
fi
 
cd /home/clickhouse
rm -rf clickhouseQueryAlert.txt
