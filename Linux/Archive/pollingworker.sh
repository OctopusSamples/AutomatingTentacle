## Set the Bash Variables

serverUrl="https://my-octopus"   # The url of your Octous server
serverCommsPort=10943            # The communication port the Octopus Server is listening on (10943 by default)
apiKey=""           # An Octopus Server api key with permission to add machines
spaceName="" # The name of the space to register the Tentacle in
name=$HOSTNAME      # The name of the Tentacle at is will appear in the Octopus portal
workerPool=""    # The worker pool to register the Tentacle in
configFilePath="/etc/octopus/default/tentacle-default.config"
applicationPath="/home/Octopus/Applications/"

# Adding Octopus Repo, Key and Installing the Tentacle/Worker

arch="x64" 
# arch="arm" # for Raspbian 32-bit
# arch="arm64" # for 64-bit OS on ARM v7+ hardware

curl -L https://octopus.com/downloads/latest/Linux_${arch}TarGz/OctopusTentacle --output tentacle-linux_${arch}.tar.gz

mkdir /opt/octopus
tar xvzf tentacle-linux_${arch}.tar.gz -C /opt/octopus

## Configure the Tentacle

/opt/octopus/tentacle/Tentacle create-instance --config "$configFilePath"
/opt/octopus/tentacle/Tentacle new-certificate --if-blank
/opt/octopus/tentacle/Tentacle configure --noListen True --reset-trust --app "$applicationPath"
echo "Registering the Tentacle $name with server $serverUrl in worker pool $workerPool"
/opt/octopus/tentacle/Tentacle register-worker --server "$serverUrl" --apiKey "$apiKey" --space "$spaceName" --name "$name" --workerPool "$workerPool" --comms-style "TentacleActive" --server-comms-port $serverCommsPort
/opt/octopus/tentacle/Tentacle service --install --start