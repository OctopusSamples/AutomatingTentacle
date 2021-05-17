## Automating the Installation of the Octopus Tentacle
choco install octopusdeploy.tentacle -y

## Set the PowerShell Variables
$OctopusServer = "http://octo1.work.local"
$OctopusServerThumbprint = "208926CD9074DEB4002E548583C26BE49194490A"
$APIKey = "API-RMRVNWTWPSIOCFIUCDFXBCCARZCH5T1"
$Role = "web server"
$Environment = "Test"
$Name = $env:computername
$PublicIP = (Invoke-WebRequest myexternalip.com/raw).content
$SpaceName = "Pattern - Rolling"

## Configure the Tentacle

cd "C:\Program Files\Octopus Deploy\Tentacle"

.\Tentacle.exe create-instance --instance "Tentacle" --config "C:\Octopus\Tentacle.config" --console
.\Tentacle.exe new-certificate --instance "Tentacle" --if-blank --console
.\Tentacle.exe configure --instance "Tentacle" --reset-trust --console
.\Tentacle.exe configure --instance "Tentacle" --home "C:\Octopus" --app "C:\Octopus\Applications" --noListen "True" --console
.\Tentacle.exe register-with --instance "Tentacle" --server "$OctopusServer" --name "$Name" --space=$SpaceName --apiKey $APIKey --comms-style "TentacleActive" --server-comms-port "10943" --environment "$Environment" --role "$role" --console
.\Tentacle.exe service --instance "Tentacle" --install --start --console