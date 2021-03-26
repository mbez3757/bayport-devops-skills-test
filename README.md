
# Welcome

![Bayport](/Bayport_Logo.png)

Welcome to Bayport's DevOps skills assessment.
Please use this template to create your own repository of this test and share your repo with us. Please answer all questions on this assessment.

# Linux
* What is the command to list the contents of a direcory, line by line and ordered by size ascending in human readable format?
>Answer:
```
ls -laSrh my_directory/
```

* How would you add a DNS server to a network interface in Linux?
>Answer:
```
Add the DNS server to the /etc/resolv.conf The entry will look like this: 
nameserver 192.168.2.254
```

* If the DNS server you've just added is not reachable, how can you get any particular hostname to resolve locally? 
>Answer:
```
You have to specify the order of resolving names. The following hosts entry in /etc/nsswitch.conf will first check /etc/hosts: 
hosts: files dns
```

* How would you check for SELinux related errors?
>Answer:
```
You can check the SELinux Audit log, usually at path /var/log/audit/audit.log You can also use setroubleshoot package to give more meaning to the log
```

* Write the commands to add 30GB disk space to a logical volume named "docker" that belongs to a logical group named "docker-group".
>Answer:
```
Assumptions-> The physical volume is /dev/hdd, the common filesystem is ext4 and is extended to volume group docker-group	
i)  Create logical volume: 
    lvcreate -L +30G --name docker docker-group
ii) Create filesystem. This is required since the logical volume doesn''t create the filesystem: 
    mkfs -t ext4 /dev/docker-group/docker
iii) Add a filesystem label named "docker". Makes it easy to identify the filesystem with regards to a crash or disk problems:
	 e2label /dev/docker-group/docker docker
iv) Add it to the Linux /etc/fstab file:
	/dev/docker-group/docker   /mnt/docker                       ext4     defaults        0 0
v) Mount the filesystem:
	sudo mount /dev/docker-group/docker /mnt/docker
```

* In the root of this repository, create a Bash script called "listit.sh", when executed, this script must do the following (in order):
    * Create a file called directories.list that contains the directory names only of the current directory.
    * Add a line at the beginning of the directories.list file that reads "line one's line".
    * Output the first three lines of directories.list on the console.
    * Accept an integer parameter when executed and repeat the previous question's output x amount of times based on the parameter provided at execution.

>Answer:
Please see the listit.sh file in root

* Commit and push your changes.

# Docker
* In the root of this repository, create a Dockerfile that is based on the latest mariadb image.
    * Expose port 3307.
    * Define an evironment variable called BRUCE with a value of WAYNE.
    * Run a command that will output the value from BRUCE into a file called BATCAVE in the root directory of the container. 
* Create a Bash script in the root of this repository called FLY.sh that will do the following:
    * Install Docker if it is not yet installed.
    * Ensure the installed version of Docker is the latest version available.
    * Start a container using the image you've craeted above with your Dockerfile - this container must run as follows:
        * It must be named ALFRED.
        * It must mount /var/lib/mysql to the host operating system to /var/lib/mysql.
        * It must mount /BATCAVE to the host operating system.
    * Checks whether a container exists called ALFRED and if it does, removes an recreates it.
    * Create a schema in the database called "wayneindustries" with one table in it called "fox" with columns "ID" and "Name".
    * Insert an entry with ID "50" and Name "BATMOBILE".
* Create an encrypted file called "secret" in the root of this repository that contains the root password of the database (the password must be "thisisadatabasepassword123456789!").
* Change your Bash script to start the conainer using the root password from the "secret" file.
  
>Answer:
Please see the Dockerfile, FLY.sh, secret.gpg files in root

* Commit and push your changes.



# OpenShift / OKD
For the questions below, please make use of the OpenShift CLI (oc) where applicable.
* Write the command used to login to a remote OpenShift cluster.
>Answer:
```
oc login <host> --insecure-skip-tls-verify --username <user> --password <password>
```

* Write the command to add the "cluster-admin" cluster role to a user called "clark".
>Answer:
```
oc adm policy add-cluster-role-to-user cluster-admin clark  
```

* Write the command used to list all pods in the "smallville" project (namespace).
>Answer:
```
oc project smallville
oc get pods
```

* Write the command to scale an application (deployment config) called "dailyplanet" to 2 pods.
>Answer:
```
oc scale dc dailyplanet --replicas=2
```

* Write the command to gain remote shell access to a pod called "lex" in the "smallville" project (namespace).
>Answer:
```
oc project smallville
oc rsh lex
```

* Write the command to export a secret called "loislane" in JSon format, the secret is in the "dailyplanet" project (namespace).
>Answer:
```
oc project dailyplanet
oc export -o json secret loislane > loislane_secret.json
```

* Add a file called "Krypton" (in YAML format) to this repo that contains the resource defintion for a Persistent Volume Claim with the following properties:
    * Points to a Persistent Volume called "zod".
    * Requests 5GB of storage.
    * The volume can be mounted as read-write by more than one node.
>Answer:
Please see Krypton.yml file in root


# General
* How would you ensure any change made to this Dockerfile is source controlled, approved, tested and deployed. Explain which tools you will use as if this was going into a production environment.
>Answer:
```
I will use git to create a repo containing the Dockerfile which will be controlled and versioned. Within the repo another branch, namely development, will be created from the master branch.
In order to ensure that any changes are approved and tested and to ensure continues integration and deployemnt, Jenkins will be used. A multibranch pipeline will be created to build automatically as soon as changes are committed to the branches.
In the Jenkins development pipeline the git development branch files will be checked out, the development docker image will be build and the container will be created. If anything is wrong with the container it will not start and that will be the first failure point to check. If the containers run, unit tests and integration tests will be executed to ensure code quality. If these stages pass the docker images will be pushed to the development Openshift cluster where the database service will be made available via a route/end point.
In the Jenkins production pipeline the development branch files will be merged into the master branch by using git rebase. The production docker image will be built and will be pushed to the production Openshift cluster where the database service will be made available via a route/end point.
In terms of monitoring I will add Telegraf to the Dockerfile to provide metrics on the service. The metrics will then be collected by Prometheus and can be used on Grafana to visualize the metrics. Some of the metrics will include: the status of the service (is it up and running); the number of calls made to the service (check per HTTP code); the database calls to pinpoint any performance issues at a specific time. 
```

* Commit and push your changes.
