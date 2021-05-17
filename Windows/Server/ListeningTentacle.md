# Automating the Installation of the Octopus Tentacle
choco install octopusdeploy.tentacle -y


## Set the PowerShell Variables
$OctopusServer = "http://myoctopusurl"
$OctopusServerThumbprint = ""
$APIKey = ""
$Role = ""
$Environment = ""
$Name = $env:computername
$PublicIP = (Invoke-WebRequest myexternalip.com/raw).content
$SpaceName = ""

## Opening the Firewall

"netsh" advfirewall firewall add rule "name=Octopus Deploy Tentacle" dir=in action=allow protocol=TCP localport=10933


## Configure the Tentacle
cd "C:\Program Files\Octopus Deploy\Tentacle"

.\Tentacle.exe create-instance --instance "Tentacle" --config "C:\Octopus\Tentacle.config" --console
.\Tentacle.exe new-certificate --instance "Tentacle" --if-blank --console
.\Tentacle.exe configure --instance "Tentacle" --reset-trust --console
.\Tentacle.exe configure --instance "Tentacle" --home "C:\Octopus" --app "C:\Octopus\Applications" --port "10933" --console
.\Tentacle.exe configure --instance "Tentacle" --trust "$OctopusServerThumbprint" --console
"netsh" advfirewall firewall add rule "name=Octopus Deploy Tentacle" dir=in action=allow protocol=TCP localport=10933
.\Tentacle.exe register-with --instance "Tentacle" --server "$OctopusServer" --apiKey="$APIKey" --role "$Role" --environment "$Environment" --comms-style TentaclePassive --console
.\Tentacle.exe service --instance "Tentacle" --install --start --console