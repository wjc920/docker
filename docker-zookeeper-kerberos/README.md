# ZooKeeper Dev/Test setup

Needed a docker container for developing a project of mine. However, I could not find any good existing containers that had at least 3.5 + of ZooKeeper + Kerberos installed. In the end, I decided to make my own with ZooKeeper-3.4.14 installed.

Took a lot of help by the docker setup Phunt has (https://github.com/phunt/zk-docker-devenv/tree/master/kerberos.centos.6.7).

Run
```
$ docker run -d --name zookeeper -h localhost -p 2181:2181 -p 88:88/udp -p 88:88/tcp -p 749:749 meldrum/docker-zookeeper-kerberos
```



