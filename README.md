# AutomatingTentacle

This repository contains automation scripts to install and configure Octopus Tentacle on different OS's. 

## Linux

- Redhat, Fedora & CentOS 7 and 8
- Debian 
- Archive

### Public IP's and Hostnames

When registering Linux Targets and Workers, Octopus assumes that they are addressable using your local DNS. If you are dealing with public IPs or Hostnames, consider adding a  bash variable for the public IP or Hostname similar to **publicIp=$(curl -s https://ifconfig.info)**. 

Using **[register-with](https://octopus.com/docs/octopus-rest-api/tentacle.exe-command-line/register-with.md)**, you can specify the IP or the public hostname. 

### Administrative commands

Every organization is different, and the examples provided here use [sudo](https://www.linux.com/tutorials/linux-101-introduction-sudo/). They are intended to demonstrate functionality. Ensure you comply with your company's security policies when you configure any user accounts and that your specific implementation matches your needs.

Some of the below will need Sudo access unless running from a secure shell.


## Windows

- Server 2012
- Server 2012 R2
- Server 2016
- Server 2019