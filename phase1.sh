#!/bin/sh

# Paranoia mode
set -e
set -u

# Je récupere le hostname du serveur
HOSTNAME="$(hostname)"
export DEBIAN_FRONTEND=noninteractive

# Si la machine ne s'appelle pas control
if [ "$HOSTNAME" != "control" ]; then

    # configuration du puppet.conf
    sed -i \
        -e '/## BEGIN PROVISION/,/## END PROVISION/d' \
        /etc/puppet/puppet.conf
    cat >/etc/puppet/puppet.conf <<-MARK
## BEGIN PROVISION
[main] 
ssldir = /var/lib/puppet/ssl
certname = $HOSTNAME
server = control
environment = production 
[master]
vardir = /var/lib/puppet
cadir  = /var/lib/puppet/ssl/ca
dns_alt_names = puppet   
## END PROVISION
	MARK

	#relancer le puppet agent
	systemctl restart puppet

	#déclarer les noms au Puppet Master
	puppet agent --test || true
fi

