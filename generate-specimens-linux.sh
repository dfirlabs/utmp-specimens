#!/bin/bash
#
# Script to generate utmp test files
# Requires Linux

make

sudo /usr/bin/touch /var/run/utmp
sudo /home/ubuntu/generate

cp /var/run/utmp specimens/
