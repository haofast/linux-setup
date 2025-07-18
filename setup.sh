#!/bin/sh

# update sources with "contrib non-free"
sed -i '/^deb.*deb.debian.org\/debian\/.*main/s/main/& contrib non-free/' /etc/apt/sources.list

# add x86 architecture support
dpkg --add-architecture i386

# update package index
apt-get update
apt-get install --assume-yes \
  kde-plasma-desktop \
  cups \
  print-manager \
  network-manager \
  kde-spectacle \
  kcalc \
  okular \
  ark \
  gwenview \
  vlc \
  firefox-esr \
  timeshift \
  thunderbird \
  libreoffice \
  libreoffice-kf5 \
  neofetch \
  btop \
  rclone \
  flatpak \
  snapd \
  plasma-discover-backend-flatpak \
  plasma-discover-backend-snap

# remove bundled apps
apt-get purge --assume-yes konqueror* zutty* imagemagick*
apt-get autopurge --assume-yes

# flatpak app setup
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub -y dev.vencord.Vesktop com.visualstudio.code

# nvidia driver setup
gpu=$(lspci | grep -i '.* vga .* nvidia .*')

if [ "$gpu == *NVIDIA*" ]; then
  apt install --assume-yes nvidia-detect
  nvidia_driver_version=$(nvidia-detect | awk '/recommended to install the/{getline;print$NF}')
  apt install --assume-yes $nvidia_driver_version
fi

# clear interfaces file
reboot