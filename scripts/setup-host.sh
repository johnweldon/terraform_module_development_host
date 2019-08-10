#!/usr/bin/env bash
# shellcheck disable=SC2164

set -x
exec > /var/log/user-data.log 2>&1

echo "Update machine"
sudo apt update
sudo apt dist-upgrade -y
sudo apt install -y vim git

echo "Install go"
curl -fsSL https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz | \
	sudo tar -C /usr/local -zxf -

echo "Install chezmoi"
mkdir -p ~/build
(cd ~/build; git clone https://github.com/twpayne/chezmoi)
(cd ~/build/chezmoi; git checkout v1.6.1; /usr/local/go/bin/go install .)

echo "Create chezmoi source folder"
mkdir -p ~/.local/share
(cd ~/.local/share; git clone https://github.com/johnweldon/dotfiles.chezmoi chezmoi; chmod 0700 chezmoi)


echo "Configure chezmoi"
mkdir -p ~/.config/chezmoi
cp /tmp/chezmoi.yaml ~/.config/chezmoi/

echo "Apply chezmoi"
~/go/bin/chezmoi apply


echo "Install docker"
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sudo sh /tmp/get-docker.sh
sudo usermod -aG docker "$USER"
sudo docker swarm init

echo "Configure docker"
mkdir -p ~/.docker
cp /tmp/config.json ~/.docker/
chmod 0700 ~/.docker
chmod 0600 ~/.docker/config.json
(cd ~/build; git clone git@github.com:johnweldon/web-compose docker)
(cd ~/build/docker; sudo ./up)
