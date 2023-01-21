#!/bin/bash
#0. cleanup
docker rm -f $(docker ps -a -q)

#1. create a directory
sudo mkdir -p /var/jenkins_home/workspace/task1
cd ..

#1. clone my repo
git clone https://github.com/MatanelAshuri/jtask.git
cd task1/jcasc

#2. replace localhost with IP
sed -i "s/localhost/$(hostname -I | awk '{print $1}')/g" casc.yaml

#7. inject ip list as input parameter
#ip_list=$(paste -d, -s /tmp/servers.list)
#sed -i "s/10.10.10.10/$ip_list/g" casc.yaml
#sed -i "s/localhost/$(hostname -I | awk '{print $1}')/g" casc.yaml


#2. build jenkins as code
docker build -t jenkins:jcasc .

#10. run jenkins as code

sudo docker run --name jenkins -u root -v $(which docker):/usr/bin/docker -v /var/run/docker.sock:/var/run/docker.sock -v /var/jenkins_home/workspace/tsunami-scanner:/var/jenkins_home/workspace/tsunami-scanner --rm -p 8080:8080 --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD=password jenkins:jcasc
