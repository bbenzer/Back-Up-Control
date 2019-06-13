#!/bin/python
import pandas
import os
import subprocess
import datetime
from datetime import datetime, timedelta, tzinfo
import time
import smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEBase import MIMEBase
from email import Encoders



with open(r"/root/script/backupcheck/backup.txt") as f:
        with open(r"/root/script/backupcheck/backup2.txt", 'w') as f1:
            for lines in f:

                fields = lines.rstrip().split(";")
                Hostname = fields[0]
                Start = fields[1].strip()
                End = fields[2].strip()
                Start1 = datetime.strptime(Start, '%Y-%m-%dT%H:%M:%SZ')
                End2 =datetime.strptime(End, '%Y-%m-%dT%H:%M:%SZ')
                delta = End2 - Start1

                f1.write(Hostname + ";"+ str(Start1) +";"+ str(End2)+ ";"+ str(delta)+"\n")

        f1.close()

f.close()

now = datetime.now()
workbookname = 'Linux_Servers_Weekly_Report'+ now.strftime("%Y-%m-%d")+'.xlsx'
df1 = pandas.read_csv(r"/root/script/backupcheck/backup2.txt", sep = ';', header = None, encoding = "UTF-8")
df1.columns = ["Hostname","Backup Start Date","Backup End Date","Backup Complete Time"]
df2 = pandas.read_csv(r"/root/script/backupcheck/unknown.list", header = None, encoding = "UTF-8")
df2.columns = ["Hostname"]
df3 = pandas.read_csv(r"/root/script/backupcheck/priv.out", sep = ';', header = None, encoding = "UTF-8")
df3.columns = ["Hostname", "User", "Description"]
df4 = pandas.read_csv(r"/root/script/backupcheck/security.out", sep = ';', header = None, encoding = "UTF-8")
df4.columns = ["Security Check"]
df5 = pandas.read_csv(r"/tmp/ntp.check",  header = None, encoding = "UTF-8")
df5.columns = ["Ntp Check"]

writer = pandas.ExcelWriter('/root/workbookname.xlsx')
df1.to_excel(writer, 'Completed Backup List')
df2.to_excel(writer, 'Uncompleted Backup List')
df3.to_excel(writer, 'Privilidge Check')
df4.to_excel(writer, 'Security Check')
df5.to_excel(writer, 'Ntp Check')

writer.save()

os.rename('/root/workbookname.xlsx','/root/'+workbookname)



SUBJECT = "Linux Servers Weekly Report " + now.strftime("%Y-%m-%d %H:%M")
EMAIL_FROM = 'report@xxx.com'
EMAIL_TO = ["x1@xxx.com"]

msg = MIMEMultipart()
msg['Subject'] = SUBJECT
msg['From'] = EMAIL_FROM
msg['To'] = ", ".join(EMAIL_TO)



part = MIMEBase('application', "octet-stream")
part.set_payload(open(workbookname, "rb").read())
Encoders.encode_base64(part)


part.add_header('Content-Disposition', 'attachment; filename="'+workbookname+'"')

msg.attach(part)

server = smtplib.SMTP("smtpmailserver")
server.sendmail(EMAIL_FROM, EMAIL_TO, msg.as_string())

