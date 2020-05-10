docker build -t krb-server .
docker build -t krb-client .
docker network create --subnet=192.168.0.0/16 wjc-test
docker run -itd -p 749:749 -p 88:88 --name kdc kdc

docker-compose -f docker-compose.yml up -d
