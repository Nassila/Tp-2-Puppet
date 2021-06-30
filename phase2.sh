#!/bin/sh

# Paranoia mode
set -e
set -u

HOSTNAME="$(hostname)"

# J'utilise /etc/hosts pour associer les IP aux noms de domaines
# sur mon réseau local, sur chacune des machines
sed -i \
	-e '/^## BEGIN PROVISION/,/^## END PROVISION/d' \
	/etc/hosts
cat >> /etc/hosts <<MARK
## BEGIN PROVISION
192.168.50.250      control
192.168.50.10       server0
192.168.50.20       server1
192.168.50.30       server2
192.168.50.40       server3
192.168.50.50       server4
192.168.50.60       server5
## END PROVISION
MARK

# Désactive l'update automatique du cache apt + indexation (lourd en CPU)
cat >> /etc/apt/apt.conf.d/99periodic-disable <<MARK
APT::Periodic::Enable "0";
MARK

#Autorisez l'accès des autres serveurs sur CONTROL
if [ "$HOSTNAME" != "control" ]; then 
    puppet cert sign control
fi 

echo "SUCCESS."

