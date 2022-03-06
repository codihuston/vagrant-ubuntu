#!/usr/bin/env bash
# Docker
# Git
# Go 1.17
# KinD
# Podman
# Python
# Ruby 3
# Summon

source /etc/os-release

sudo apt-get update

# Install general tooling
sudo apt-get install -y ncat \
  nmap \
  build-essential \
  manpages-dev \
  dnsutils \
  curl

# Install Docker
sudo apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -a -G docker vagrant

# Install Git
sudo apt-get install -y git-all

# Install Go
sudo mkdir -p /usr/local/go
GO_TARBALL=go1.17.8.linux-amd64.tar.gz
sudo wget -c "https://go.dev/dl/$GO_TARBALL"
sudo tar -C /usr/local -xzf "$GO_TARBALL"
rm -rf "$GO_TARBALL"
echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/vagrant/.bashrc

# KinD
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl kubectl.sha256

# OC
mkdir -p ocbin && \
    wget -O oc.tar.gz "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.7.35/openshift-client-linux.tar.gz" && \
    tar xvf oc.tar.gz -C ocbin && \
    sudo cp "$(find ./ocbin -name 'oc' -type f | tail -1)"  /usr/local/bin/oc  && \
    rm -rf ocbin oc.tar.gz

# Podman
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install podman

# pip
sudo apt-get -y install python3-pip

# Ruby 3 (rbenv)
sudo apt-get -y install libssl-dev \
  libreadline-dev \
  zlib1g-dev \
  autoconf \
  bison \
  build-essential \
  libyaml-dev \
  libreadline-dev \
  libncurses5-dev \
  libffi-dev \
  libgdbm-dev

git clone https://github.com/rbenv/rbenv.git /home/vagrant/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.bashrc
echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bashrc
git clone https://github.com/rbenv/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
chown -R vagrant /home/vagrant/.rbenv

# Summon
eco "Installing summon..."

wget -O summon.tar.gz "https://github.com/cyberark/summon/releases/download/v0.9.1/summon-linux-amd64.tar.gz" && \
  tar xvf summon.tar.gz && \
  sudo cp "$(find ./summon -name 'summon' -type f | tail -1)"  /usr/local/bin/summon  && \
  rm -rf summon.tar.gz && \
  rm summon

sudo curl -sSL https://raw.githubusercontent.com/cyberark/summon-conjur/main/install.sh | bash
echo 'export SUMMON_PROVIDER_PATH=/usr/local/lib/summon' >> /home/vagrant/.bash_profile
