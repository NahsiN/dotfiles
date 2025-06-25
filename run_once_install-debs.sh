#!/bin/sh

sudo apt update
sudo apt install -y nala

# podman
sudo nala install -y podman podman-compose

#d ocker
# Add Docker's official GPG key:
sudo nala install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo nala update

sudo nala install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# sudo docker run hello-world


sudo groupadd docker
sudo usermod -aG docker $USER

# emacs
sudo add-apt-repository -y ppa:ubuntuhandbook1/emacs
sudo nala update
sudo nala install -y emacs emacs-common

# tailscale
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

sudo nala update
sudo nala install -y tailscale

sudo tailscale up --accept-routes
# tailscale ip -4


# signal
# NOTE: These instructions only work for 64-bit Debian-based
# Linux distributions such as Ubuntu, Mint etc.

# 1. Install our official public software signing key:
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg;
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

# 2. Add our repository to your list of repositories:
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
  sudo tee /etc/apt/sources.list.d/signal-xenial.list

# 3. Update your package database and install Signal:
sudo nala update && sudo nala install -y signal-desktop

# vscode
sudo apt-get install wget gpg

#wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
#sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
#echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
#rm -f packages.microsoft.gpg

# inspired from copilot.microsoft.com
# Download the Microsoft GPG key only if needed
keyring_path="/etc/apt/keyrings/packages.microsoft.gpg"
if [ ! -f "$keyring_path" ]; then
  echo "Installing Microsoft GPG key..."
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee "$keyring_path" > /dev/null
  sudo chmod 644 "$keyring_path"
else
  echo "Microsoft GPG key already exists at $keyring_path"
fi

# Add the VS Code repo if not already present
source_list="/etc/apt/sources.list.d/vscode.list"
source_entry="deb [arch=amd64,arm64,armhf signed-by=$keyring_path] https://packages.microsoft.com/repos/code stable main"

if [ ! -f "$source_list" ] || ! grep -Fxq "$source_entry" "$source_list"; then
  echo "Adding VS Code repository..."
  echo "$source_entry" | sudo tee "$source_list" > /dev/null
else
  echo "VS Code repository is already configured."
fi


sudo nala install -y apt-transport-https
sudo nala update
sudo nala install -y code # or code-insiders

echo "Log out and log back in so that your docker group membership is re-evaluated."


