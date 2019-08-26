#!/bin/bash
DB_NAME=$1
APP_PORT=$2
MNG_PORT=$3
EMAIL=$4
PASS=$5

#Gerar String de Conexao
/root/docker/aspnetcore22/GerarStringConnection.sh 'db_'$DB_NAME

#Copiar o arquivo gerado
cp /root/docker/aspnetcore22/appsettings.json /root/docker/aspnetcore22/APICotacoes/

#Gerar Compose
/root/projeto/GerarCompose.sh $DB_NAME $APP_PORT $MNG_PORT $EMAIL $PASS
#Gerar a imagem do cliente
cd /root/docker/aspnetcore22/ && docker build . -t api:$1

#Subir o container
cd /root/projeto/ &&
docker-compose up -d
