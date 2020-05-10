#!/bin/bash

echo $KRB_SERVER >> /etc/hosts
KADMIN_PRINCIPAL_FULL=$KADMIN_PRINCIPAL@$REALM

function kadminCommand {
    echo "kadmin -p $KADMIN_PRINCIPAL_FULL -w $KADMIN_PASSWORD -q $1"
    kadmin -p $KADMIN_PRINCIPAL_FULL -w $KADMIN_PASSWORD -q "$1"
}

tee /etc/krb5.conf <<EOF
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 default_realm = $REALM
 dns_lookup_realm = false
 dns_lookup_kdc = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 allow_weak_crypto = true

[realms]
	$REALM = {
		kdc = $KDC_KADMIN_SERVER
		admin_server = $KDC_KADMIN_SERVER
		default_domain = $DEFAULT_DOMAIN
	}

[domain_realm]
 .$DEFAULT_DOMAIN = $REALM
 $DEFAULT_DOMAIN = $REALM
EOF


until kadminCommand "list_principals $KADMIN_PRINCIPAL_FULL"; do

  >&2 echo "KDC is unavailable - sleeping 1 sec"
  sleep 1
done
echo "KDC and Kadmin are operational"
echo ""