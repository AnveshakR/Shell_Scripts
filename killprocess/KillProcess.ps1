[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

$title = 'Kill process'
$msg   = 'Enter process name:'

$text = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)

$process = Get-Process -Name *$text*

$process | Get-Process | Format-Table ProcessName, Id -AutoSize

$id = [Microsoft.VisualBasic.Interaction]::InputBox("Which Id" ,"Enter Id number")

if($id -eq "all")
{Get-Process -Name *$text* | Stop-Process -Force}

else
{Get-Process -Id $id | Stop-Process -Force}