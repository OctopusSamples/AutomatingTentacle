# AutomatingTentacle

This repository contains automation scripts to install and configure Octopus Tentacle on different OS's. 

## Networking

Each Operating System listed here, will have a polling and a listening tentacle option listed. 

### Listening Tentacles/Workers

By default, Octopus uses port 10933 for a Listening Tentacle and Listening Workers. The Octopus server connects directly or via a Proxy to an endpointing listening on 10933. You will need to add Port 10933 to the inbound firewall rules to the server, and allow the server to be connected over a private or public network. This may involve opening a port on a hardware load balancer or firewall. 

### Polling Tentacles/Workers

By default, Octopus server listens on 10943 for Polling Tentacles/Workers connections, or whatever the default is when you set up Octopus. On the Polling Tentacles/Workers, you will need to connect to this port. This may involve allowing outbound connections on your local server/endpoint. Additionally, you may need to allow non-default outbound connections on 10943. If you have a firewall blocking all traffic apart from Port 80/443 then you may need to configure your server to listen using [websockets](https://octopus.com/docs/infrastructure/deployment-targets/windows-targets/polling-tentacles-web-sockets). 

## Linux

- [Redhat, Fedora & CentOS 7 and 8](/Linux/Redhat)
- [Debian, Ubuntu, Mint, Kali](/Linux/Debian) 
- [Archive](/Linux/Archive)

### Public IP's and Hostnames

When registering Linux Targets and Workers, Octopus assumes that they are addressable using your local DNS. If you are dealing with public IPs or Hostnames, consider adding a  bash variable for the public IP or Hostname similar to **publicIp=$(curl -s https://ifconfig.info)**. 

Using **[register-with](https://octopus.com/docs/octopus-rest-api/tentacle.exe-command-line/register-with.md)**, you can specify the IP or the public hostname.

Please be careful as your outbound IP, may be different from your inbound IP and it's worth getting this information and specifying it in environments you don't own. 

### Additional Dependencies

This repo will not deal with additional dependencies required on your Linux or Windows Octopus Deployment targets. If you require .NET Core, for instance, then you will need to automate this or carry it out manually. 

### Administrative commands

Every organization is different, and the examples provided here use [sudo](https://www.linux.com/tutorials/linux-101-introduction-sudo/). They are intended to demonstrate functionality. Ensure you comply with your company's security policies when you configure any user accounts and that your specific implementation matches your needs.

Some of the below will need Sudo access unless running from a secure shell.

## Windows

- Server 2012
- Server 2012 R2
- Server 2016
- Server 2019

For a full list of compatible OS versions, you can check our [Operating System Compatibility](https://octopus.com/docs/support/compatibility#operating-system-compatibility) doc.

All of these use the same script and you can see them [here](/Windows/Server)

### Public IP's and Hostnames

When registering Windows Targets and Workers, Octopus assumes that they are addressable using your local DNS. If you are dealing with public IPs or Hostnames, consider adding a PowerShell variable for the public IP or Hostname similar to **$PublicIP = (Invoke-WebRequest myexternalip.com/raw).content**. 

Using **[register-with](https://octopus.com/docs/octopus-rest-api/tentacle.exe-command-line/register-with.md)**, you can specify the IP or the public hostname.

Please be careful as your outbound IP, may be different from your inbound IP and it's worth getting this information and specifying it in environments you don't own. 

### Administrative commands

Every organization is different, and the examples provided here elevated PowerShell. They are intended to demonstrate functionality. Ensure you comply with your company's security policies when you configure any user accounts and that your specific implementation matches your needs.

Some of the below will need Sudo access unless running from a secure shell.

For a full list of required permissions on Windows for the Octopus Tentacle please check [Running Tentacle under a specific user account](https://octopus.com/docs/infrastructure/deployment-targets/windows-targets/running-tentacle-under-a-specific-user-account)

## Registering Polling Tentacle & Workers on HA Nodes

If you are using Octopus High-Availability, and registering either a Polling Tentacle or Worker then you will need to do it to each node in your HA cluster. Please check out [Polling Tentacles with HA](https://octopus.com/docs/administration/high-availability/maintain/polling-tentacles-with-ha) as this explains the concept in full. 

### Debian Single Node Example

We're going to assume that you're registering the below:


:::bash
serverUrl="https://my-octopus"   # The url of your Octous server
serverCommsPort=10943            # The communication port the Octopus Server is listening on (10943 by default)
apiKey=""           # An Octopus Server api key with permission to add machines
spaceName="" # The name of the space to register the Tentacle in
name=$HOSTNAME      # The name of the Tentacle at is will appear in the Octopus portal
environment=""  # The environment to register the Tentacle in
role=""   # The role to assign to the Tentacle
configFilePath="/etc/octopus/default/tentacle-default.config"
applicationPath="/home/Octopus/Applications/"
:::

#### Adding Octopus Repo, Key and Installing the Tentacle/Worker

:::bash
apt-key adv --fetch-keys https://apt.octopus.com/public.key
add-apt-repository "deb https://apt.octopus.com/ stretch main"
apt-get update
apt-get install tentacle
:::

#### Configure the Tentacle

:::bash
/opt/octopus/tentacle/Tentacle create-instance --config "$configFilePath"
/opt/octopus/tentacle/Tentacle new-certificate --if-blank
/opt/octopus/tentacle/Tentacle configure --noListen True --reset-trust --app "$applicationPath"
echo "Registering the Tentacle $name with server $serverUrl in environment $environment with role $role"
/opt/octopus/tentacle/Tentacle register-with --server "$serverUrl" --apiKey "$apiKey" --space "$spaceName" --name "$name" --env "$environment" --role "$role" --comms-style "TentacleActive" --server-comms-port $serverCommsPort
/opt/octopus/tentacle/Tentacle service --install --start
:::

You would need to take the above and change it, so that you can register it to **octo1** and **octo2**

Please see the changes in **bold**

:::bash
**server1Url="https:/octo1"   # The url of your Octous server**
**server2Url="https:/octo2"   # The url of your Octous server**
serverCommsPort=10943            # The communication port the Octopus Server is listening on (10943 by default)
apiKey=""           # An Octopus Server api key with permission to add machines
spaceName="" # The name of the space to register the Tentacle in
name=$HOSTNAME      # The name of the Tentacle at is will appear in the Octopus portal
environment=""  # The environment to register the Tentacle in
role=""   # The role to assign to the Tentacle
configFilePath="/etc/octopus/default/tentacle-default.config"
applicationPath="/home/Octopus/Applications/"
:::

# Adding Octopus Repo, Key and Installing the Tentacle/Worker

:::bash
apt-key adv --fetch-keys https://apt.octopus.com/public.key
add-apt-repository "deb https://apt.octopus.com/ stretch main"
apt-get update
apt-get install tentacle
:::

## Configure the Tentacle

:::bash
/opt/octopus/tentacle/Tentacle create-instance --config "$configFilePath"
/opt/octopus/tentacle/Tentacle new-certificate --if-blank
/opt/octopus/tentacle/Tentacle configure --noListen True --reset-trust --app "$applicationPath"
**echo "Registering the Tentacle $name with server $server1Url in environment $environment with role $role"
/opt/octopus/tentacle/Tentacle register-with --server "$server1Url" --apiKey "$apiKey" --space "$spaceName" --name "$name" --env "$environment" --role "$role" --comms-style "TentacleActive" --server-comms-port $serverCommsPort
echo "Registering the Tentacle $name with server $server2Url in environment $environment with role $role"
/opt/octopus/tentacle/Tentacle register-with --server "$server2Url" --apiKey "$apiKey" --space "$spaceName" --name "$name" --env "$environment" --role "$role" --comms-style "TentacleActive" --server-comms-port $serverCommsPort**

/opt/octopus/tentacle/Tentacle service --install --start
:::

