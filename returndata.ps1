Import-Module VMware.VimAutomation.Core

Connect-VIServer odin -Port 443 -User administrator@vsphere.local -Password Aztr@2018

$CurrentDate = Get-Date
$CurrentDate = $CurrentDate.ToString('MM-dd-yyyy_hh-mm-ss')

Get-VM | Get-Annotation -CustomAttribute "Last EMC vProxy Backup"  | select @{N='VM';E={$_.AnnotatedEntity}},Value | Export-Csv "C:\Users\xxx\data.txt$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).txt"

Disconnect-VIServer -confirm:$false
