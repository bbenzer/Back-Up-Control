option echo off
option batch on
option confirm off
open sftp://username:password@serverip 
lcd "C:\Users\txtfilepath"
put -nopermissions -nopreservetime "C:\Users\exportedfilepath"
exit 
