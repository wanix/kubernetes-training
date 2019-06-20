#!/bin/bash

# Install basic packages
yum update -y
yum install -y vim wget docker kubectl

# Start services
systemctl enable --now docker