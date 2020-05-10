#! /bin/bash
echo "$KRB_SERVER" >> /etc/hosts
echo -e "$CLUSTER_INFO" >> /etc/hosts

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

tee /opt/zookeeper-3.4.14/conf/jaas.conf <<EOF
Server {
  com.sun.security.auth.module.Krb5LoginModule required
  debug=true
  useKeyTab=true
  keyTab="/opt/zookeeper-3.4.14/conf/zookeeper.keytab"
  storeKey=true
  useTicketCache=false
  principal="zookeeper/$HOST_NAME@$REALM";
};

Client {
  com.sun.security.auth.module.Krb5LoginModule required
  debug=true
  useKeyTab=true
  keyTab="/opt/zookeeper-3.4.14/conf/zookeeper-client.keytab"
  storeKey=true
  useTicketCache=false
  principal="zookeeper-client/$HOST_NAME@$REALM";
};
EOF
echo "wjc"
echo "$ZOO_SERVERS"
echo -e "$ZOO_SERVERS" >> /opt/zookeeper-3.4.14/conf/zoo.cfg
cat /opt/zookeeper-3.4.14/conf/zoo.cfg

tee /opt/zookeeper-3.4.14/conf/java.env <<EOF
export JVMFLAGS="-Djava.security.auth.login.config=/opt/zookeeper-3.4.14/conf/jaas.conf -Dsun.security.krb5.debug=true -Dzookeeper.allowSaslFailedClients=false"
EOF

cd /opt/zookeeper-3.4.14/conf

kadmin -p ${KADMIN_PRINCIPAL}@${REALM} -w $KADMIN_PASSWORD <<EOF
addprinc -randkey zookeeper/$HOST_NAME@${REALM}
addprinc -randkey zookeeper-client/$HOST_NAME@${REALM}
xst -k zookeeper.keytab zookeeper/$HOST_NAME@${REALM}
xst -k zookeeper-client.keytab zookeeper-client/$HOST_NAME@${REALM}
exit
EOF

kdestroy

cd /opt/zookeeper-3.4.14

# Start ZooKeeper
./bin/zkServer.sh start-foreground

