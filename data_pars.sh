#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/lbin/:/root/bin:/opt/OV/bin:/opt/OV/bin/OpC:/root/bin

export PATH

mv /home/xxx/custom_* /root/script/backupcheck/
/bin/chown root: /root/script/backupcheck/custom_*
/bin/chmod 777 /root/script/backupcheck/custom_*
/bin/cat /root/script/backupcheck/custom_* | grep -v "Backup*" | grep -v "Value" | grep -v "#" | awk -F '\"' '{print $2}' | sort | uniq >| /root/script/backupcheck/unknown.list
/bin/cat  /root/script/backupcheck/custom_* |  awk -F '=' '{ print $1";"$7";"$8 }' | sort -n  > /root/script/backupcheck/file1.txt
/bin/sed 's/yyyy-MM-dd'T'HH:mm:ss'Z'/${today}/g' /root/script/backupcheck/file1.txt > /root/script/backupcheck/file2.txt
/bin/sed  's/^M$//' /root/script/backupcheck/file2.txt > /root/script/backupcheck/file3.txt
/bin/cat /root/script/backupcheck/file3.txt | grep -v ';;' > /root/script/backupcheck/file4.txt
/bin/sed 's/"Backup Server/""/g; s/EndTime/""/g; s/"//g ; s/,//g; s/""//g ' /root/script/backupcheck/file4.txt > /root/script/backupcheck/file5.txt 
/bin/mv /root/script/backupcheck/file5.txt /root/script/backupcheck/backup.list
/bin/cat /root/script/backupcheck/backup.list | tr -d "[:blank:]" > /root/script/backupcheck/backup.txt
sleep 10s
/bin/python /root/script/backupcheck/report.py
sleep 30s
today=$(date +%Y%m%d)
mv /root/script/backupcheck/unknown.list /root/script/backupcheck/logs/unknown.list$today
mv /root/script/backupcheck/custom_*     /root/script/backupcheck/logs/coredata/
mv /root/script/backupcheck/backup2.txt  /root/script/backupcheck/logs/backuplist/backup2$today
mv /root/Linux_Server_Backup_List*       /root/script/backupcheck/logs/excel/
rm /root/script/backupcheck/file1.txt  
rm /root/script/backupcheck/file2.txt  
rm /root/script/backupcheck/file3.txt 
rm /root/script/backupcheck/file4.txt 
rm /root/script/backupcheck/file5.txt 
rm /root/script/backupcheck/backup.txt
rm /root/script/backupcheck/backup.list
