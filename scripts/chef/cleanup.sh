#!/bin/bash
# Remove items used for building, since they aren't needed anymore

sudo apt-get -y autoremove
sudo apt-get clean

#Clean up tmp
sudo rm -rf /tmp/*

sudo passwd -d ubuntu
sudo rm /home/ubuntu/.ssh/authorized_keys