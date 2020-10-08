#!/bin/bash

PS3='What linux flavour do you use, please enter your choice: '
options=("Ubuntu" "Debian" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Ubuntu")
            echo "Starting!"
			sleep 5
			sudo apt update -y && sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common wget -y
			echo "Adding docker to your apt repositories"
			sleep 5
			curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
			sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
			echo "Installing docker engine"
			sleep 5
			sudo apt update -y && sudo apt upgrade -y && sudo apt install docker-ce docker-ce-cli containerd.io -y
			sudo systemctl enable docker
			sudo docker volume create portainer_data
			sudo docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
            break
			;;
        "Debian")
            echo "Starting!"
			sleep 5
			sudo apt update -y && sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common wget -y
			echo "Adding docker to your apt repositories"
			sleep 5
			curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
			sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
			echo "Installing docker engine"
			sleep 5
			sudo apt update -y && sudo apt upgrade -y && sudo apt install docker-ce docker-ce-cli containerd.io -y
			sudo docker volume create portainer_data
			sudo docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
            break
			;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
