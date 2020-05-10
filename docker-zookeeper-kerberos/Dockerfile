FROM centos:centos7
COPY CentOS7-Base-163.repo /etc/yum.repos.d/

RUN yum clean all

RUN yum install -y \
 krb5-libs \
 krb5-workstation \
 java-1.8.0-openjdk-headless \
 wget \
 tar 

RUN wget -q -O - https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz | tar -xzf - -C /opt

# ADD ./jaas.conf /opt/zookeeper-3.4.14/conf/jaas.conf
ADD ./zoo.cfg /opt/zookeeper-3.4.14/conf/zoo.cfg
# ADD ./java.env /opt/zookeeper-3.4.14/conf/java.env
# ADD ./krb5.conf /root/krb5.conf

ADD ./zookeeper_setup.sh /
ADD ./zk-entrypoint.sh /

RUN chmod 777 /zookeeper_setup.sh && \
 chmod 777 /zk-entrypoint.sh
# Set up ZooKeeper
RUN /zookeeper_setup.sh

EXPOSE 2181 88/udp 88/tcp 749
RUN yum clean all

ENV REALM ${REALM:-WJC920.KRB}
ENV KADMIN_PRINCIPAL ${KADMIN_PRINCIPAL:-admin/admin}
ENV KADMIN_PASSWORD ${KADMIN_PASSWORD:-123456}
ENV KDC_KADMIN_SERVER ${KDC_KADMIN_SERVER:-kdc.wjc920.krb}
ENV DEFAULT_DOMAIN ${DEFAULT_DOMAIN:-wjc920.krb}
ENV HOST_NAME zoo${ZOO_MY_ID:-1}
ENV ZOO_SERVERS $ZOO_SERVERS
ENV ZOO_MY_ID ${ZOO_MY_ID:-1}
ENV KRB_SERVER ${KRB_SERVER:-192.168.11.1 kdc.wjc920.krb}


ENTRYPOINT ["/zk-entrypoint.sh"]
