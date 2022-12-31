$allow_obs_quit = $false
$active_process = $null # stores the process variable of the active process
$active_process_name = "" # stores the name of the active process
$active_scene = $null # store the scene name of the active process

$Path = $PSScriptRoot+"\values.txt"
$data = Get-Content $Path

$process_names = @()
$scene_names = @()

foreach ($e in $data) # getting values of process names and corresponding scenes from values.txt
{
    $process_names += [string]$e.Split('=')[0]
    $scene_names += [string]$e.Split('=')[1]
}

while($true) # main while loop
{

    while ($null -eq $active_process) # while no active game is detected
    {
        $cnt = 0
        foreach ($i in $process_names) # loop through the process names
        {
            $process = Get-Process $i -ErrorAction SilentlyContinue
            if ($process) # if matching process is found, then save the name, process variable and scene name
            {
                $active_process_name = $i
                $active_process = $process
                $active_scene = $scene_names[$cnt]
                break
            }
            $cnt+=1
        }
    }

    while ($true) # runs till broken
    {
        $active_process = Get-Process $active_process_name -ErrorAction SilentlyContinue
        $obs = Get-Process obs64 -ErrorAction SilentlyContinue

        if ($active_process) # if the selected process is still running
        {
            if ($obs -or $allow_obs_quit) # and if OBS is running or if allow_obs_quit flag is triggered
            {
                continue
            }
            else # if OBS is not running but game is (for the first instance)
            {
                $allow_obs_quit = $true # raise flag
                # start OBS replay buffer with corresponding scene
                Start-Process -FilePath "C:\Program Files\obs-studio\bin\64bit\obs64.exe" -WorkingDirectory "C:\Program Files\obs-studio\bin\64bit" -ArgumentList "--scene $active_scene", "--startreplaybuffer"
            }
        }
        else # if the game is shut down
        {
            if ($obs -or $allow_obs_quit) # and if OBS is running
            {
                # shut down obs and open the recording folder
                $obs | Stop-Process
                $obs_folder = Get-Content ($env:APPDATA+"\obs-studio\basic\profiles\Untitled\basic.ini") | Where-Object {$_ -match "="} | ConvertFrom-StringData
                Get-ChildItem $obs_folder.FilePath *.mkv | ForEach-Object {Remove-Item $_.FullName}
                Start-Process $obs_folder.FilePath
                $allow_obs_quit = $false
            }
            else 
            {
                continue
            }
            break
        }
        Start-Sleep -Seconds 60 # sleep in between
    }
    $active_process = $null
}