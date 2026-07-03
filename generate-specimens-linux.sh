#!/bin/bash
#
# Script to generate utmp test files
# Requires Linux

make

sudo /home/ubuntu/generate

cp /var/log/wtmp specimens/
