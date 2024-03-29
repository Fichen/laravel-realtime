#!/bin/bash

sudo apt-get update -y

if [ -x "$(command -v apache2)" ];then
	sudo apt-get remove --purge apache2 -y
	sudo apt autoremove -y
fi

# database docker-compose.yml
if [ ! -d "/var/db/mysql" ]; then
	sudo mkdir -p /var/db/mysql
fi

# docroot directory
if [ ! -d "/var/www/html" ]; then
	sudo mkdir -p /var/www/html
fi

# hosts
if [ -f "/tmp/hosts" ]; then
	sudo mv -f /tmp/hosts /etc/hosts
fi

# firewall
if [ -f "/tmp/ufw" ]; then
	sudo mv -f /tmp/ufw /etc/default/ufw
fi

# Swap memory
if [ ! -f "/swapdir/swapfile" ]; then
	sudo mkdir /swapdir
	cd /swapdir
	sudo dd if=/dev/zero of=/swapdir/swapfile bs=1024 count=2000000
  	sudo chmod 600 /swapdir/swapfile
	sudo mkswap -f  /swapdir/swapfile
	sudo swapon swapfile
	echo "/swapdir/swapfile       none    swap    sw      0       0" | sudo tee -a /etc/fstab /etc/fstab
	sudo sysctl vm.swappiness=10
	echo vm.swappiness = 10 | sudo tee -a /etc/sysctl.conf
fi


# Docker install
if [ ! -x "$(command -v docker)" ]; then
	sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

	curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" > /tmp/docker_gpg
    sudo apt-key add < /tmp/docker_gpg && sudo rm -f /tmp/docker_gpg
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    curl -L https://github.com/docker/compose/releases/download/1.24.0-rc3/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

	sudo apt-get update -y

	sudo apt-get install --no-install-recommends -y docker-ce

	sudo systemctl enable docker
else
    echo "Docker installed: $(sudo docker version)"
    echo "Docker-compose installed: $(sudo docker-compose version)"
fi

#if [ ! -x "$(command -v node)" ]; then
    #sudo apt install -y build-essential
    #curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
    #nvm install node
  #export NVM_DIR="$HOME/.nvm"
  #[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  #[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  #nvm --version
  #nvm install node

    #curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    #echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    #sudo apt-get update && sudo apt-get install yarn

#else
#    echo "Node installed: $(nodejs -v)"
#fi

if [ ! -x "$(command npm)" ]; then
    sudo apt install -y npm
else
    echo "npm installed: $(npm version)"
fi

sudo docker-compose  -f /var/www/html/docker-compose.yml up -d