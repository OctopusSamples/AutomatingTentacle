serverUrl="https://my-octopus"   # The url of your Octous server
thumbprint=""       # The thumbprint of your Octopus Server
apiKey=""           # An Octopus Server api key with permission to add machines
spaceName="Default" # The name of the space to register the Tentacle in
name=$HOSTNAME      # The name of the Tentacle at is will appear in the Octopus portal
workerPool="Default Worker Pool"    # The worker pool to register the Tentacle in
configFilePath="/etc/octopus/default/tentacle-default.config"
applicationPath="/home/Octopus/Applications/"

arch="x64" 
# arch="arm" # for Raspbian 32-bit
# arch="arm64" # for 64-bit OS on ARM v7+ hardware

curl -L https://octopus.com/downloads/latest/Linux_${arch}TarGz/OctopusTentacle --output tentacle-linux_${arch}.tar.gz

mkdir /opt/octopus
tar xvzf tentacle-linux_${arch}.tar.gz -C /opt/octopus

/opt/octopus/tentacle/Tentacle create-instance --config "$configFilePath"
/opt/octopus/tentacle/Tentacle new-certificate --if-blank
/opt/octopus/tentacle/Tentacle configure --port 10933 --noListen False --reset-trust --app "$applicationPath"
/opt/octopus/tentacle/Tentacle configure --trust $thumbprint
echo "Registering the Tentacle $name with server $serverUrl in worker pool $workerPool"
/opt/octopus/tentacle/Tentacle register-worker --server "$serverUrl" --apiKey "$apiKey" --space "$spaceName" --name "$name" --workerPool "$workerPool" --space "$spaceName"
/opt/octopus/tentacle/Tentacle service --install --start