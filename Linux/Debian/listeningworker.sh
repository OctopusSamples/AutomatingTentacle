## Set the Bash Variables

serverUrl="https://my-octopus"   # The url of your Octous server
thumbprint=""       # The thumbprint of your Octopus Server
apiKey=""           # An Octopus Server api key with permission to add machines
spaceName="" # The name of the space to register the Tentacle in
name=$HOSTNAME      # The name of the Tentacle at is will appear in the Octopus portal
workerPool=""    # The worker pool to register the Tentacle in
configFilePath="/etc/octopus/default/tentacle-default.config"
applicationPath="/home/Octopus/Applications/"

# Adding Octopus Repo, Key and Installing the Tentacle/Worker

apt-key adv --fetch-keys https://apt.octopus.com/public.key
add-apt-repository "deb https://apt.octopus.com/ stretch main"
apt-get update
apt-get install tentacle

## Configure the Tentacle

/opt/octopus/tentacle/Tentacle create-instance --config "$configFilePath"
/opt/octopus/tentacle/Tentacle new-certificate --if-blank
/opt/octopus/tentacle/Tentacle configure --port 10933 --noListen False --reset-trust --app "$applicationPath"
/opt/octopus/tentacle/Tentacle configure --trust $thumbprint
echo "Registering the Tentacle $name with server $serverUrl in worker pool $workerPool"
/opt/octopus/tentacle/Tentacle register-worker --server "$serverUrl" --apiKey "$apiKey" --space "$spaceName" --name "$name" --workerPool "$workerPool"
/opt/octopus/tentacle/Tentacle service --install --start