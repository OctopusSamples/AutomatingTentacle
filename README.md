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
- [Debian](/Linux/Debian) 
- [Archive](/Linux/Archive)

### Public IP's and Hostnames

When registering Linux Targets and Workers, Octopus assumes that they are addressable using your local DNS. If you are dealing with public IPs or Hostnames, consider adding a  bash variable for the public IP or Hostname similar to **publicIp=$(curl -s https://ifconfig.info)**. 

Using **[register-with](https://octopus.com/docs/octopus-rest-api/tentacle.exe-command-line/register-with.md)**, you can specify the IP or the public hostname.

Please be careful as your outbound IP, may be different from your inbound IP and it's worth getting this information and specifying it in environments you don't own. 

### Administrative commands

Every organization is different, and the examples provided here use [sudo](https://www.linux.com/tutorials/linux-101-introduction-sudo/). They are intended to demonstrate functionality. Ensure you comply with your company's security policies when you configure any user accounts and that your specific implementation matches your needs.

Some of the below will need Sudo access unless running from a secure shell.

## Windows

- Server 2012
- Server 2012 R2
- Server 2016
- Server 2019

All of these use the same script and you can see them [here](/Windows/Server)

### Public IP's and Hostnames

When registering Windows Targets and Workers, Octopus assumes that they are addressable using your local DNS. If you are dealing with public IPs or Hostnames, consider adding a PowerShell variable for the public IP or Hostname similar to **$PublicIP = (Invoke-WebRequest myexternalip.com/raw).content**. 

Using **[register-with](https://octopus.com/docs/octopus-rest-api/tentacle.exe-command-line/register-with.md)**, you can specify the IP or the public hostname.

Please be careful as your outbound IP, may be different from your inbound IP and it's worth getting this information and specifying it in environments you don't own. 

### Administrative commands

Every organization is different, and the examples provided here elevated PowerShell. They are intended to demonstrate functionality. Ensure you comply with your company's security policies when you configure any user accounts and that your specific implementation matches your needs.

Some of the below will need Sudo access unless running from a secure shell.

For a full list of required permissions on Windows for the Octopus Tentacle please check [Running Tentacle under a specific user account](https://octopus.com/docs/infrastructure/deployment-targets/windows-targets/running-tentacle-under-a-specific-user-account)
