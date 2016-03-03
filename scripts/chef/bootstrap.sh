#!/bin/bash
# Initial Downloads and config

sudo mkdir -p /tmp/chef && sudo chown -R vagrant:vagrant /tmp/chef
sudo mkdir -p /tmp/config && sudo chown -R vagrant:vagrant /tmp/config
sudo mkdir -p /etc/chef && sudo chown -R vagrant:vagrant /etc/chef
sudo mkdir -p /tmp/packer-chef-client && sudo chown -R vagrant:vagrant /tmp/packer-chef-client
sudo mkdir -p /etc/chef/ohai/hints
