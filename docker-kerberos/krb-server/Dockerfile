FROM centos:centos7
COPY CentOS7-Base-163.repo /etc/yum.repos.d/

EXPOSE 749 88

RUN yum clean all
RUN yum install -y wget

RUN yum install -y krb5-server krb5-libs krb5-workstation \
 tar
COPY init-script.sh /
RUN chmod 777 /init-script.sh


ENV REALM ${REALM:-WJC920.KRB}
ENV KADMIN_PRINCIPAL ${KADMIN_PRINCIPAL:-admin/admin}
ENV KADMIN_PASSWORD ${KADMIN_PASSWORD:-123456}
ENV MASTER_PASSWORD ${MASTER_PASSWORD:-123456}
ENV KDC_KADMIN_SERVER ${KDC_KADMIN_SERVER:-kdc.wjc920.krb}
ENV DEFAULT_DOMAIN ${DEFAULT_DOMAIN:-wjc920.krb}


ENTRYPOINT ["/init-script.sh"]
