#!/bin/bash
# Initial Downloads and config

sudo mkdir -p /tmp/chef && sudo chown -R ubuntu:ubuntu /tmp/chef
sudo mkdir -p /tmp/config && sudo chown -R ubuntu:ubuntu /tmp/config
sudo mkdir -p /etc/chef && sudo chown -R root:root /etc/chef
sudo mkdir -p /tmp/packer-chef-client && sudo chown -R ubuntu:ubuntu /tmp/packer-chef-client
sudo mkdir -p /etc/chef/ohai/hints
