#!/bin/sh


NVIDIA_GPU=$(lspci | grep -i '.* vga .* nvidia .*')


if [ "NVIDIA_GPU == *NVIDIA*" ]; then
  apt install --assume-yes nvidia-detect
  nvidia_driver_version=$(nvidia-detect | awk '/recommended to install the/{getline; print $NF}')
  apt install --assume-yes $nvidia_driver_version
fi
