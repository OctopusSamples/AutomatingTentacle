serverUrl="https://my-octopus"   # The url of your Octous server
thumbprint=""       # The thumbprint of your Octopus Server
apiKey=""           # An Octopus Server api key with permission to add machines
spaceName="Default" # The name of the space to register the Tentacle in
name=$HOSTNAME      # The name of the Tentacle at is will appear in the Octopus portal
environment="Test"  # The environment to register the Tentacle in
role="web server"   # The role to assign to the Tentacle
configFilePath="/etc/octopus/default/tentacle-default.config"
applicationPath="/home/Octopus/Applications/"

apt-key adv --fetch-keys https://apt.octopus.com/public.key
add-apt-repository "deb https://apt.octopus.com/ stretch main"
apt-get update
apt-get install tentacle

/opt/octopus/tentacle/Tentacle create-instance --config "$configFilePath"
/opt/octopus/tentacle/Tentacle new-certificate --if-blank
/opt/octopus/tentacle/Tentacle configure --port 10933 --noListen False --reset-trust --app "$applicationPath"
/opt/octopus/tentacle/Tentacle configure --trust $thumbprint
echo "Registering the Tentacle $name with server $serverUrl in environment $environment with role $role"
/opt/octopus/tentacle/Tentacle register-with --server "$serverUrl" --apiKey "$apiKey" --space "$spaceName" --name "$name" --env "$environment" --role "$role"
/opt/octopus/tentacle/Tentacle service --install --start