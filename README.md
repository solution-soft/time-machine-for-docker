# Time Machine for Docker #

Time Machine® is a software product providing virtual clocks that enable you to time travel your applications into the future or the past, facilitating time shift testing on your date and time sensitive application logic, such as month end, quarter end, year-end processing, billing cycle, work flow, regulatory go live, and policy life cycle.

Time Machine is transparent to applications and databases so no code modification is required to do time shift testing and the system clock is never modified. Time Machine eliminates the need to reset the system clock, which is time consuming, error prone and not possible under Active Directory, in a Kerberos secured or SSL enabled environment.

Time Machine® for Docker enables time travel in docker containers by providing
a series of Docker images with Time Machine installed.

## Using Time Machine in Docker containers ##

To use Time Machine (TM) with Docker containers, a host copy of TM should be first installed on the main host system that serves the containers. It is a prerequisite for running of TM in the containers successfully as containers share the same address space as the host. 

No license for this host TM is needed, unless time travel is also required for the host system (in addition to containers).

In case that containers will be running on multiple hosts, each of those hosts must have host TM installed as well.

You can download host version of TM from the following location:

`ftp://ftp.solution-soft.com/pub/tm/docker/Linux/redhat/`

In the same location, you'll also find a `tm_linux_docker_host_readme.txt` file that explains the installation steps in more details.

This host version of TM also has the TM Floating License Server (TMFLS) bundled with it, and it is automatically installed along side with TM on the host.

TMFLS will provide licensing for TM in the containers you'll create. To enable TMFLS, you will need to acquire a license key from SolutionSoft Systems, Inc.

Please refer to the file `tm_linux_docker_host_readme.txt` on how to install TM and to license & configure TMFLS.


## Creating containers with Time Machine pre-installed ##

After TM is installed on the host(s), to create containers that will use TM, you can use preconfigured *Solution-Soft* docker images that have TM already installed and are available from the Docker Hub.

To check the list of currently available images, please open the following link:

`https://hub.docker.com/u/solutionsoft`

To download and use any of the available container images, click on the desired image name, and once the page of that image appears, look at the description of the Docker Pull Command needed to be executed on your host to download the image. Also, please check for any additional relevant info in the Overview section (if available), with regards to the usage of the image.

For example, to download the latest TM image for CentOS 7 (assuming you have docker service already installed and running on your host), you would need to run:

```# docker pull solutionsoft/time-machine-for-centos7:latest```

or to download the latest TM image for RHEL 7, you would need to run:

```# docker pull solutionsoft/time-machine-for-rhel7:latest```


Each of the available docker images has TM preinstalled, and configured to use a license from a TMFLS. It is typically served from the host on which the containers are running.

TMFLS target is specified by the environment variables `TM_LICHOST`, `TM_LICPORT` and `TM_LICPASS`. `TM_LICHOST` is the IP address of the host on which TMFLS is running. `TM_LICPORT` is the TCP port number to communicate with TMFLS and the default value is 57777. `TM_LICPASS` is the security code that must match the security code from TMFLS and the default value is "docker".


Before creating a container from the preconfigured image, we first need to create a directory on the host to keep the persistent data for a container, since TM stores some persistent data (such as log files, or persistent virtual clocks info). Let's assume we'll use directory `/var/tm/tmdata1` for the TMAgent persistent data and logs. To create such a directory, use the following command:

```# mkdir -p /var/tm/tmdata1```

We can then use the following command to start/create a container in a detached mode:

```
# docker run -d --rm \
  -e TM_LICHOST=192.168.20.112 \
  -e TM_LICPORT=57777 \
  -e TM_LICPASS=docker \
  -p 17800:7800 \
  -v /var/tm/tmdata1:/tmdata \
  solutionsoft/time-machine-for-centos7:latest
```

This will return a hash string representing the detached container ID. For example: `be3c8f15dc20cf0b1279f6532a54bab2dde831b92feaf60f43d859c9f837a466`.

Some explanation here:

1. as described above, we use environment variables `TM_LICHOST`, `TM_LICPORT` and `TM_LICPASS` to allow TM in the container to automatically check out a license from TMFLS; In this example 192.168.20.112 is the IP address of the host that runs the containers, and at the same time TMFLS.

2.  TMAgent port 7800 inside the container is mapped to 17800 in the local machine;

	Please note that when creating containers from the Docker images, for each running container you need to make sure to map a different available port from the host to the port 7800 in the container. TM Agent (Time Machine component) from the container will listen on that port for remote requests from the Management Console and other products from the Time Machine Suite.

3. local directory `/var/tm/tmdata1` is mapped to `/tmdata` in the container, where we keep the TMAgent persistent data and logs.
Please note that when running multiple containers on the same host, you need to map different directories on the host to store persistent data for each container.

The host TMFLS is pre-configured with default listening port value of 57777 and security key 'docker'. It means that, by default, you will only need to pass on to the container the environment variable for the actual IP address of your host (which is also the the IP address of TMFLS), while the values for the Listening Port (57777) and the Security Key ('docker') would match without the need for a change. Of course, if you want to change the values for the listening port and the security key, you can do so by passing on all three environment variables (just like it is done in the example above).

As soon as you create/run the container, the license is checked out from the TMFLS, and you can create virtual clocks in that container. How many licenses from TMFLS can be used simultaneously depends on the size of TMFLS License Unit Pool.

You can use the following command to check the container status:

```
# docker ps
CONTAINER ID   IMAGE                                         COMMAND                 CREATED         STATUS         PORTS                     NAMES
be3c8f15dc20   solutionsoft/time-machine-for-centos7:12.9R2  "/entrypoint.sh /usrÖ"  5 seconds ago   Up 3 seconds   0.0.0.0:17800->7800/tcp   adoring_euclid
```

With the container running in the background, you can spawn a shell session to the container and check from the inside:

```
# docker exec -it be3c8f15dc20 /bin/bash
[root@be3c8f15dc20 /]# cd /opt/solutionsoft/timemachine/
[root@be3c8f15dc20 timemachine]# cat licserverhost
192.168.20.112:57777:docker
[root@be3c8f15dc20 timemachine]# cd /tmdata1
[root@be3c8f15dc20 tmdata]# ls -R data
data:
_db.dat
[root@be3c8f15dc20 tmdata]#
```

To stop the container, run the following command:
	
```# docker container stop be3c8f15dc20```

As soon as you stop the container, the license is released back to the TMFLS, and it will become available to another container.

If you want to create multiple containers with docker run command (like described above), you will need to run the command each time for a new container, changing the host port value and host directory that need to be mapped to the new container.


## Manage Time Machine containers using docker-compose ##

Beside using the command docker run to create containers from preconfigured images that have TM preinstalled, you can also use docker-compose tool to easily create multiple containers with TM running, using a single command.

Docker-compose is a tool provided by Docker to define and operate single or multi-container applications.

For further reference, please go to: `https://docs.docker.com/compose`

According to its design, one should use a YAML file to specify the application instance. By default, this YAML file takes the name 'docker-compose.yml'.

In the following example, we will show how to use docker-compose to define a single and multiple Docker/Time Machine configuration. We will assume that all the containers will run in the current working directory.


### Single Application Configuration ###

This is a single TM docker configuration:

```
# mkdir ./tmdata1
# cat docker-compose.yml
version: '3.1'

services:
	centos7:
		image: solutionsoft/time-machine-for-centos7:latest
		container_name: time-machine-for-centos7
		restart: always
		environment:
  			- TM_LICHOST=192.168.20.112
  			- TM_LICPORT=57777
  			- TM_LICPASS=docker
		ports:
  			- "17800:7800"
		volumes:
  			- "./tmdata1:/tmdata"
```

To start this instance:

```# docker-compose up -d```

To stop this instance:

```# docker-compose down```


### Multiple Application Configuration ###

Let's assume that we will configure three applications, with their persistent data stored at `./tmdata1`, `./tmdata2`, `./tmdata3`, respectively.  In addition, their TMagent listening ports will be 17800, 27800 and 37800, respectively.

```
# mkdir -p ./tmdata1 ./tmdata2 ./tmdata3
# cat docker-compose.yml
version: '3.1'

services:

	one:
		image: solutionsoft/time-machine-for-centos7:latest
		container_name: time-machine-for-centos7-1
		restart: always
		environment:
  			- TM_LICHOST=192.168.20.112
  			- TM_LICPORT=57777
  			- TM_LICPASS=docker
		ports:
  			- "17800:7800"
		volumes:
  			- "./tmdata1:/tmdata"

	two:
		image: solutionsoft/time-machine-for-centos7:latest
		container_name: time-machine-for-centos7-2
		restart: always
		environment:
	      - TM_LICHOST=192.168.20.112
	      - TM_LICPORT=57777
	      - TM_LICPASS=docker
		ports:
	  		- "27800:7800"
		volumes:
	  		- "./tmdata2:/tmdata"

	three:
		image: solutionsoft/time-machine-for-centos7:latest
		container_name: time-machine-for-centos7-3
		restart: always
		environment:
  			- TM_LICHOST=192.168.20.112
  			- TM_LICPORT=57777
  			- TM_LICPASS=docker
		ports:
  			- "37800:7800"
		volumes:
  			- "./tmdata3:/tmdata"
```

To start all the applications:

```# docker-compose up -d```
To stop all the applications:

```# docker-compose down```

To start one application `two`:

```# docker-compose up two -d```

To stop one application `three`:

```# docker-compose down three```

Please note that applications `one`, `two` and `three` will all be operating in the same docker subnet.

## Operate Time Machine inside the Container ##

Once you have containers with Time Machine running, to manage Time Machine inside the containers, you can use a docker command to spawn a shell session to a respective container and issue TM commands from the command line:

```# docker exec -it be3c8f15dc20 /bin/bash```

Fo your convenience, a container created from Solution-Soft preconfigured docker images has a single existing user called time-traveler, and a user group of the same name:

```
[root@be3c8f15dc20 /]# id time-traveler
uid=999(time-traveler) gid=998(time-traveler) groups=998(time-traveler)
```

This user can be used 'out-of-the-box' to test TM functionality, and assigning a virtual clock to that user would be done as in the example below:

```
[root@be3c8f15dc20 /]# tmuser -a -u time-traveler -y 6
# this command time shifts the user time-traveler 6 years into the future

Copyright(c) 1997 - 2019 SolutionSoft Systems, Inc. All Rights Reserved.
Time Machine tmuser utility version 12.9R3 for Linux Kernel 2.6 or up,
for managing virtual clocks at the command line.

tmuser: uid 999 has been added with a Running virtual clock: Wed Apr 23 09:36:41 2025
```

To check what virtual clocks are currently existing on your system:

```
[root@be3c8f15dc20 /]# tmuser -l
Copyright(c) 1997 - 2019 SolutionSoft Systems, Inc. All Rights Reserved.
Time Machine tmuser utility version 12.9R3 for Linux Kernel 2.6 or up,
for managing virtual clocks at the command line.

tmuser: report: Listing all virtual clocks:
Id         Clock type                Clock date/time
u:time-traveler Running                   Wed Apr 23 09:38:03 2025

- End of list -
tmuser: All Time Machine users have been listed above.
```

To double check that the user actually sees virtual time, you can do the following:

```
[root@be3c8f15dc20 /]# su time-traveler
bash-4.2$ date
Wed Apr 23 09:41:34 UTC 2025
```

At the same time, other users are unaffected by the virtual time:

```
bash-4.2$ exit
exit
[root@ee2cbfbeafca /]# date
Tue Apr 23 09:43:41 UTC 2019
```

To delete the virtual clock and revert user time-traveler to system time, you can run the following command:

```
[root@ee2cbfbeafca /]# tmuser -d -u time-traveler 
Copyright(c) 1997 - 2019 SolutionSoft Systems, Inc. All Rights Reserved.
Time Machine tmuser utility version 12.9R3 for Linux Kernel 2.6 or up,
for managing virtual clocks at the command line.

tmuser: report: Virtual clock for uid 999 has been deleted
```

You can also use the TM Management Console (Java based GUI that comes bundled with TM on the host) to manage Time Machine in each of your containers. See TM Management Console documentation for more details (by default located under `/etc/ssstm/tmconsole/` on the host).

So, for example, if you're running three containers on your host, by mapping host's ports 17800, 27800 and 37800 to redirect the traffic to respective containers' port 7800, you'll be able to connect your TM Management Console to all three in parallel, choosing TM Agent type of connection and using the following connection strings, respectively:

```
localhost:17800

localhost:27800

localhost:37800 
```

Once you connect to a container via TM console, you'll be able to create virtual clocks for OS users and affect all processes running under those users (among others, the processes of DB or App servers for example).

Please note that initially, the user time-traveler will be hidden in the Console, and to assign a virtual clock for such a user, please refer to TM Management Console user manual, located under `/etc/ssstm/tmconsole/` on the host. Adding such users is specifically described in SECTION 3. LOCAL TIME MACHINE MANAGEMENT, subsection C. CONFIGURE VIRTUAL TIME FOR OS GROUPS AND USERS. 

If your containers span multiple hosts, then you can use an enhanced version of the Console, called TM Enterprise Management Console to manage them all from a Windows system with one console. 

You can download the Enterprise Console from the following location:

```ftp://ftp.solution-soft.com/pub/tm/tmconsole/enterprise/```

In the same directory, you can find a readme-tmconsole-enterprise.txt file, that explains how to install and license it. Once installed, a detailed manual is also available in the installation folder.

With the Enterprise Console, you would use slightly different connection strings to connect to our example containers, specifying the actual IP of the host on which they are running (in this example it is 192.168.20.112):

```
192.168.20.112:17800

192.168.20.112:27800

192.168.20.112:37800
```

The Enterprise Console offers additional capabilities such as creating virtual clocks for specific processes (PIDs), in that way providing more granularity, for example if you want to only time travel a DB Server instance, and not the other processes owned by the user that also owns the DB instance.

It also allows you to connect from a single control point to multiple hosts that have containers, unlike the regular console that can only connect to the host on which it is running.

Also, if Linux host that runs containers, does not have X Window System enabled to run a GUI such as regular TM Console, it could be more convenient to use any Windows machine to remotely manage Time Machine in the containers via the Enterprise Console.

To read more about TM Enterprise Management Console, please refer to:

```https://solution-soft.com/sites/default/files/wysiwyg/TM%20Enterprise%20Management%20Console_4.pdf```


In a situation when you need to simultaneously time travel multiple containers, you would use another product from Time Machine Suite, namely Time Machine Sync Server.

Let's assume a scenario where you have containerized a multi-tiered environment, and you have your DB Server, App Server and your client-side all in separate containers. In such a scenario, if you needed to time travel all three simultaneously, you would use the Sync Server to group together containers into a single Sync Group and time travel the whole group to a desired virtual time.

The Sync Server also has a built-in comprehensive URL API that provides the ability to set virtual time and manage a Sync Group programmatically. You can make a HTTP or HTTPS call to the API as part of an automated testing script to enable the Sync Group, then proceed through the scripted test case(s), change the virtual time for the Sync Group to accommodate the next date centric test cases and when virtual clocks are no longer needed, the Sync Group can be disabled via the API. 

Like with all the other products from the Time Machine Suite, TM Management Console (either regular or Enterprise version) is used as a GUI to manage the Sync Server as well.

You can download TM Sync Server from the following location:

```ftp://ftp.solution-soft.com/pub/tm/tmsync/```

After you open the above location in a browser, you can traverse through the available directories to choose the OS where you want to install it. When you locate the desired directory, next to the install package, you'll find a readme_tmss.txt file that explains how to install and license the Sync Server.

Once installed, a detailed manual is also available in the installation folder.

To read more about TM Sync Server, please refer to:

```https://solution-soft.com/sites/default/files/wysiwyg/TM%20Sync%20Server%20Data%20Sheet_0.pdf```


# Contact Support #

NOTE: If you have any technical support questions or need an evaluation key, please contact us at:
    
    SolutionSoft Systems, Inc.
    Phone: +1 408 346 1414
    Email: support@solution-soft.com
    Web: www.solution-soft.com

For more detailed information, please check the TM manual (tmmanual.txt).


