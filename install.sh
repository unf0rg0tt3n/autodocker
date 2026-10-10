#!/bin/bash

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo."
  exit 1
fi

PS3='What linux flavor do you use, please enter your choice: '
options=("Ubuntu" "Debian" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Ubuntu")
            echo "Starting!"
			apt update -y && apt install apt-transport-https ca-certificates curl gnupg wget lsb-release -y
			echo "Adding docker to your apt repositories"
			install -m 0755 -d /etc/apt/keyrings
			curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
			chmod a+r /etc/apt/keyrings/docker.asc
			echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
			echo "Installing docker engine"
			apt update -y && apt upgrade -y && apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
			systemctl enable docker
			docker volume create portainer_data
			docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
            break
			;;
        "Debian")
            echo "Starting!"
			apt update -y && apt install apt-transport-https ca-certificates curl gnupg wget lsb-release -y
			echo "Adding docker to your apt repositories"
			install -m 0755 -d /etc/apt/keyrings
			curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
			chmod a+r /etc/apt/keyrings/docker.asc
			echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
			echo "Installing docker engine"
			apt update -y && apt upgrade -y && apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
			docker volume create portainer_data
			docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
            break
			;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
