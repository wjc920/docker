#!/bin/bash

ZOOKEEPER_VER="zookeeper-3.4.14"

mkdir -p /opt/$ZOOKEEPER_VER/data
touch /opt/$ZOOKEEPER_VER/data/myid
echo $ZOO_MY_ID > /opt/$ZOOKEEPER_VER/data/myid

