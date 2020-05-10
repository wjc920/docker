#! /bin/sh

echo "127.0.0.1 ${KDC_KADMIN_SERVER}" >> /etc/hosts

echo "*/admin@${REALM} *" > /var/kerberos/krb5kdc/kadm5.acl

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

tee /var/kerberos/krb5kdc/kdc.conf <<EOF
[kdcdefaults]
    kdc_listen = 88
    kdc_tcp_listen = 88

[realms]
    $REALM = {
        kadmind_port = 749
        max_life = 12h 0m 0s
        max_renewable_life = 7d 0h 0m 0s
        master_key_type = aes256-cts
        supported_enctypes = aes256-cts:normal aes128-cts:normal
        # If the default location does not suit your setup,
        # explicitly configure the following values:
        # database_name = /var/krb5kdc/principal
        # key_stash_file = /var/krb5kdc/.k5.ATHENA.MIT.EDU
        # cl_file = /var/krb5kdc/kadm5.acl
    }

[logging]
    # By default, the KDC and kadmind will log output using
    # syslog.  You can instead send log output to files like this:
    kdc = FILE:/var/log/krb5kdc.log
    admin_server = FILE:/var/log/kadmin.log
    default = FILE:/var/log/krb5lib.log
EOF

# Creating initial database
kdb5_util -r ${REALM} create -s << EOL
${MASTER_PASSWORD}
${MASTER_PASSWORD}
EOL

# Creating admin principal
kadmin.local -q "addprinc ${KADMIN_PRINCIPAL}@${REALM}" << EOL
${KADMIN_PASSWORD}
${KADMIN_PASSWORD}
EOL

# Start services
kadmind
krb5kdc

tail -f /var/log/krb5kdc.log