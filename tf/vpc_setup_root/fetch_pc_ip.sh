#!/bin/bash

# fetch pub ip of  my pc
PC_IP=$(curl -s http://checkip.amazonaws.com)
echo "pc_ip = \"${PC_IP}\"" > ip.tfvars