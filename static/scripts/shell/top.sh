
# top -u oracle -c 
top -u mysql -H -c 
top -p `ps -ef | grep smon | grep -v grep | awk '{print $2}'` 
mpstat -P ALL 1 111111