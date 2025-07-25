#!/bin/sh

ROOT_DIR=$(pwd)
APT_INSTALL_PACKAGES=$(cat ./packages/apt-install.txt | tr '\n' ' ')
APT_REMOVE_PACKAGES=$(cat ./packages/apt-remove.txt | tr '\n' ' ')
FLATPAK_PACKAGES=$(cat ./packages/flatpak.txt)
SNAP_PACKAGES=$(cat ./packages/snap.txt)


sed -i '/^deb.*deb.debian.org\/debian\/.*main/s/main/& contrib non-free/' /etc/apt/sources.list

dpkg --add-architecture i386

apt-get update

apt-get install --assume-yes $APT_INSTALL_PACKAGES

apt-get purge --assume-yes $APT_REMOVE_PACKAGES

apt-get autopurge --assume-yes

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

for package in $FLATPAK_PACKAGES;
  do flatpak install flathub -y "$package";
done

for package in $SNAP_PACKAGES;
  do snap install "$package";
done

if [ "$(lspci | grep -i '.* vga .* nvidia .*') == *NVIDIA*" ]; then
  sh ./scripts/install-nvidia-driver.sh;
fi

if [ "$(ls /proc/acpi | grep ibm) == ibm" ]; then
  for script in $(find ./configs/thinkpad/**/setup.sh); do
    cd "$ROOT_DIR" && cd $(dirname $script) && sh setup.sh
  done
fi

echo "" | tee /etc/network/interfaces

reboot
