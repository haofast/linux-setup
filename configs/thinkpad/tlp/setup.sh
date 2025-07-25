#!/bin/sh


apt-get update

apt-get install --assume-yes tlp

cat ./00-custom.conf | tee /etc/tlp.d/00-custom.conf

tlp start
