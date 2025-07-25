#!/bin/sh


apt-get update

apt-get install --assume-yes thinkfan

echo "options thinkpad_acpi fan_control=1" | tee /etc/modprobe.d/thinkpad-acpi.conf

cat ./thinkfan.conf | tee /etc/thinkfan.conf

modprobe -r thinkpad_acpi

modprobe thinkpad_acpi

systemctl enable thinkfan

thinkfan -c /etc/thinkfan.conf

cat /proc/acpi/ibm/fan
