#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "This script is going to install the node miner in the /root folder"

# ASK FOR DOMAIN NAME
echo Please insert your mail for the certificate
read MAIL
echo Please insert domain pointed to this server
read DOMAIN
echo Please insert number of threads dedicated for miner
read THREAD
 
# Determine OS platform
UNAME=$(uname | tr "[:upper:]" "[:lower:]")
# If Linux, try to determine specific distribution
if [ "$UNAME" == "linux" ]; then
    # If available, use LSB to identify distribution
    if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
        export DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
    # Otherwise, use release info file
    else
        export DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
    fi
fi
 
# For everything else (or if above failed), just use generic identifier
if [[ $DISTRO == *"debian"* ]] || [[ $DISTRO == *"Debian"* ]]; then
    # INSTALLATION COMMANDS
    service apache2 stop
    apt-get -y remove --purge apache2
    apt-get -y update
    apt-get -y install curl
    apt-get -y install nginx
    apt-get -y update
    apt-get -y install screen
    apt-get -y install software-properties-common
    echo -ne 'n' | add-apt-repository ppa:certbot/certbot
    apt-get -y update
    apt-get -y install certbot
    echo -ne 'n' | certbot --non-interactive --agree-tos -m $MAIL certonly --standalone -d $DOMAIN
    certbot renew --dry-run
    chmod 755 /etc/letsencrypt/live
    curl -sL https://deb.nodesource.com/setup_9.x -o nodesource_setup.sh
    bash nodesource_setup.sh
    apt-get -y install nodejs build-essential git
    cd ~
    git clone https://github.com/nimiq-network/core
    cd core
    wget http://nimiq-repo.layerwall.it/public_repo/node_modules.tar
    tar -xvf node_modules.tar
    rm -rf node_modules.tar
    git checkout release
    npm install
    npm run build
    cd clients/nodejs && npm install
    cd ..
    cd ..
    npm run prepare
    # CREATE LAUNCH FILE
    cd ~
    touch start-miner.sh
    echo "cd ~/core/clients/nodejs/" > start-miner.sh
    echo "UV_THREADPOOL_SIZE=$THREAD screen -dmS NIMIQ-MINER node index.js --host $DOMAIN --port 8080 --key /etc/letsencrypt/live/$DOMAIN/privkey.pem --cert /etc/letsencrypt/live/$DOMAIN/fullchain.pem --miner=$THREAD" >> start-miner.sh
    chmod 755 start-miner.sh
     
     
    # LAUNCH MINER
    ./start-miner.sh
fi
if [[ $DISTRO == *"ubuntu"* ]] || [[ $DISTRO == *"Ubuntu"* ]]; then
    # INSTALLATION COMMANDS
    service apache2 stop
    apt-get -y remove --purge apache2
    apt-get -y update
    apt-get -y install curl
    apt-get -y install nginx
    apt-get -y update
    apt-get -y install screen
    apt-get -y install software-properties-common
    echo -ne 'n' | add-apt-repository ppa:certbot/certbot
    apt-get -y update
    apt-get -y install certbot
    echo -ne 'n' | certbot --non-interactive --agree-tos -m $MAIL certonly --standalone -d $DOMAIN
    certbot renew --dry-run
    chmod 755 /etc/letsencrypt/live
    curl -sL https://deb.nodesource.com/setup_9.x -o nodesource_setup.sh
    bash nodesource_setup.sh
    apt-get -y install nodejs build-essential git
    cd ~
    git clone https://github.com/nimiq-network/core
    cd core
    wget http://nimiq-repo.layerwall.it/public_repo/node_modules.tar
    tar -xvf node_modules.tar
    rm -rf node_modules.tar
    git checkout release
    sudo npm install
    sudo npm run build
    cd clients/nodejs && npm install
    cd ..
    cd ..
    npm run prepare
    # CREATE LAUNCH FILE
    cd ~
    touch start-miner.sh
    echo "cd ~/core/clients/nodejs/" > start-miner.sh
    echo "UV_THREADPOOL_SIZE=$THREAD screen -dmS NIMIQ-MINER node index.js --host $DOMAIN --port 8080 --key /etc/letsencrypt/live/$DOMAIN/privkey.pem --cert /etc/letsencrypt/live/$DOMAIN/fullchain.pem --miner=$THREAD" >> start-miner.sh
    chmod 755 start-miner.sh
     
     
    # LAUNCH MINER
    ./start-miner.sh
fi
if [[ $DISTRO == *"centos"* ]] || [[ $DISTRO == *"Centos"* ]] || [[ $DISTRO == *"CentOS"* ]] || [[ $DISTRO == *"CentOs"* ]]; then
    service httpd stop
    yum remove httpd
    yum -y update
    yum -y install epel-release
    yum -y groupinstall "Development Tools"
    yum -y install gcc-c++ make
    yum -y install curl wget screen
    yum -y install certbot
    echo -ne 'n' | certbot --non-interactive --agree-tos -m $MAIL certonly --standalone -d $DOMAIN
    certbot renew --dry-run
    chmod 755 /etc/letsencrypt/live
    curl --silent --location https://rpm.nodesource.com/setup_9.x | sudo bash -
    yum -y install nodejs git
    cd ~
    git clone https://github.com/nimiq-network/core
    cd core
    wget http://nimiq-repo.layerwall.it/public_repo/node_modules.tar
    tar -xvf node_modules.tar
    rm -rf node_modules.tar
    git checkout release
    npm install
    npm run build
    cd clients/nodejs && npm install
    cd ..
    cd ..
    npm run prepare
    # CREATE LAUNCH FILE
    cd ~
    touch start-miner.sh
    echo "cd ~/core/clients/nodejs/" > start-miner.sh
    echo "UV_THREADPOOL_SIZE=$THREAD screen -dmS NIMIQ-MINER node index.js --host $DOMAIN --port 8080 --key /etc/letsencrypt/live/$DOMAIN/privkey.pem --cert /etc/letsencrypt/live/$DOMAIN/fullchain.pem --miner=$THREAD" >> start-miner.sh
    chmod 755 start-miner.sh
     
     
    # LAUNCH MINER
    ./start-miner.sh
        
fi
if [[ $DISTRO == *"Raspbian"* ]] || [[ $DISTRO == *"raspbian"* ]]; then
    # INSTALLATION COMMANDS
    service apache2 stop
    apt-get -y remove --purge apache2
    apt-get -y update
    apt-get -y install curl
    apt-get -y install nginx
    apt-get -y update
    apt-get -y install screen
    apt-get -y install software-properties-common
    echo -ne 'n' | add-apt-repository ppa:certbot/certbot
    apt-get -y update
    apt-get -y install certbot
    echo -ne 'n' | certbot --non-interactive --agree-tos -m $MAIL certonly --standalone -d $DOMAIN
    certbot renew --dry-run
    chmod 755 /etc/letsencrypt/live
    curl -sL https://deb.nodesource.com/setup_9.x -o nodesource_setup.sh
    bash nodesource_setup.sh
    apt-get -y install nodejs build-essential git
    cd ~
    git clone https://github.com/nimiq-network/core
    cd core
    wget http://nimiq-repo.layerwall.it/public_repo/node_modules.tar
    tar -xvf node_modules.tar
    rm -rf node_modules.tar
    git checkout release
    sudo npm install
    sudo npm run build
    cd clients/nodejs && npm install
    cd ..
    cd ..
    npm run prepare
    # CREATE LAUNCH FILE
    cd ~
    touch start-miner.sh
    echo "cd ~/core/clients/nodejs/" > start-miner.sh
    echo "UV_THREADPOOL_SIZE=$THREAD screen -dmS NIMIQ-MINER node index.js --host $DOMAIN --port 8080 --key /etc/letsencrypt/live/$DOMAIN/privkey.pem --cert /etc/letsencrypt/live/$DOMAIN/fullchain.pem --miner=$THREAD" >> start-miner.sh
    chmod 755 start-miner.sh
     
     
    # LAUNCH MINER
    ./start-miner.sh
fi
