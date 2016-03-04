#!/usr/bin/env bash

# install necessary dependencies
sudo apt-get -y -q install curl wget git vim

# Moved out of the preseed to avoid https://bugs.launchpad.net/ubuntu/+source/apt/+bug/1371058 that was introduced with Precise 12.04.5
sudo apt-get -y -q install cryptsetup build-essential libssl-dev libreadline-dev zlib1g-dev linux-source dkms nfs-common
