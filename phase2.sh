#!/bin/sh

# Paranoia mode
set -e
set -u

HOSTNAME="$(hostname)"

#Autorisez l'accès des autres serveurs sur CONTROL
if [ "$HOSTNAME" = "control" ]; then 
    puppet cert sign --all
fi 


