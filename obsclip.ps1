$allow_obs_outside = $true
$launch_obs_once = $false

while ($true) 
{
    $r6 = Get-Process firefox -ErrorAction SilentlyContinue
    $obs = Get-Process obs64 -ErrorAction SilentlyContinue
    if ($r6)
    {
        if ($obs)
        {
            continue
        }
        else 
        {
            $allow_obs_outside = $true
            Start-Process -FilePath "C:\Program Files\obs-studio\bin\64bit\obs64.exe" -WorkingDirectory "C:\Program Files\obs-studio\bin\64bit" -ArgumentList "--scene r6", "--startreplaybuffer"
        }
    }
    else 
    {
        if ($obs -and $allow_obs_outside)
        {
            $obs | Stop-Process
            $obs_folder = Get-Content ($env:APPDATA+"\obs-studio\basic\profiles\Untitled\basic.ini") | Where-Object {$_ -match "="} | ConvertFrom-StringData
            Start-Process $obs_folder.FilePath
            $allow_obs_outside = $false
        }
        else 
        {
            continue
        }
    }
    Start-Sleep -Seconds 5
}