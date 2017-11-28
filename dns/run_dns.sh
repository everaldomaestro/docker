#!/bin/bash
DOMAIN_NAME=${DOMAIN_NAME}

SERVER_ADDRESS=$(hostname -I | cut -f1 -d' ')

GATEWAY_ADDRESS=${GATEWAY_ADDRESS}

NETWORK=${NETWORK}

HOST_DNS=$(hostname -I | cut -f1 -d' ' | cut -f4 -d'.')

HOST_GW=$(echo ${GATEWAY_ADDRESS} | cut -f4 -d'.')

NETWORK_NET=''

NETWORK_SED=''

REVERSE_NET=''

NET_DOCKER=''

BIND_DIR='/etc/bind'

#Corrigir arquivo db.DOMAIN_NAME
domain_name(){
   if [ ! -e "$BIND_DIR/db.$DOMAIN_NAME" ]; then
      sed -i "s/DOMAIN_NAME/${DOMAIN_NAME}/g" $BIND_DIR/db.DOMAIN_NAME
      sed -i "s/SERVER_ADDRESS/${SERVER_ADDRESS}/g" $BIND_DIR/db.DOMAIN_NAME
      sed -i "s/GATEWAY_ADDRESS/${GATEWAY_ADDRESS}/g" $BIND_DIR/db.DOMAIN_NAME
      mv $BIND_DIR/db.DOMAIN_NAME $BIND_DIR/db.${DOMAIN_NAME}
   fi
}

#Corrigir arquivo db.REVERSE_NET
reverse_net(){
   if [ ! -e "$BIND_DIR/db.$REVERSE_NET" ]; then
      sed -i "s/DOMAIN_NAME/$DOMAIN_NAME/g" $BIND_DIR/db.REVERSE_NET
      sed -i "s/NETWORK_NET/$NETWORK_NET/g" $BIND_DIR/db.REVERSE_NET
      sed -i "s/HOST_GW/$HOST_GW/g" $BIND_DIR/db.REVERSE_NET
      sed -i "s/HOST_DNS/$HOST_DNS/g" $BIND_DIR/db.REVERSE_NET
      mv $BIND_DIR/db.REVERSE_NET $BIND_DIR/db.$REVERSE_NET
   fi
}

##Configurando arquivo named.conf.local
conf_local(){
   if [ -e "$BIND_DIR/named.conf.MATRIX" ]; then
      sed -i "s/DOMAIN_NAME/$DOMAIN_NAME/g" $BIND_DIR/named.conf.MATRIX
      sed -i "s/REVERSE_NET/$REVERSE_NET/g" $BIND_DIR/named.conf.MATRIX
      rm $BIND_DIR/named.conf.local
      mv $BIND_DIR/named.conf.MATRIX $BIND_DIR/named.conf.local
   fi
}

#Configurando arquivo named.conf.options
conf_options(){
   if [ -e "$BIND_DIR/named.conf.MATRIXOPTIONS" ]; then
      sed -i "s/NETWORK/$NETWORK_SED/g" $BIND_DIR/named.conf.MATRIXOPTIONS #NETWORK#
      sed -i "s/NET_DOCKER/$NET_DOCKER/g" $BIND_DIR/named.conf.MATRIXOPTIONS #NET_DOCKER#
      sed -i "s/SERVER_ADDRESS/$SERVER_ADDRESS/g" $BIND_DIR/named.conf.MATRIXOPTIONS #SERVER_ADDRESS
      sed -i "s/GATEWAY_ADDRESS/$GATEWAY_ADDRESS/g" $BIND_DIR/named.conf.MATRIXOPTIONS #GATEWAY_ADDRESS
      rm $BIND_DIR/named.conf.options
      mv $BIND_DIR/named.conf.MATRIXOPTIONS $BIND_DIR/named.conf.options
   fi
}

#Configurando resolv.conf
resolv_conf(){
   OPTION=$(cat /etc/resolv.conf | grep opt)

   if [ ! $(cat /etc/resolv.conf | grep $DOMAIN_NAME) ]; then
      echo -e "search $DOMAIN_NAME\nnameserver 127.0.0.1\n$OPTION" > /etc/resolv.conf
   fi
}

reverse(){
   i=3
   result=''
   while [ $i != 0 ]; do
      if [ $i == 3 ]; then
         result="$(echo $GATEWAY_ADDRESS | cut -f$i -d'.')"
      else
         result=$result."$(echo $GATEWAY_ADDRESS | cut -f$i -d'.')"
      fi
      let i--;
   done

   REVERSE_NET=$result
}

network(){
   i=1
   result=''
   while [ $i != 4 ]; do
      if [ $i == 1 ]; then
         result="$(echo $NETWORK | cut -f$i -d'.')"
      else
         result=$result."$(echo $NETWORK | cut -f$i -d'.')"
      fi
      let i++;
   done

   NETWORK_NET=$result
}

network_sed_format(){
   result=''
   result="$(echo $NETWORK | cut -f1 -d'/')"
   result=$result'\/'"$(echo $NETWORK | cut -f2 -d'/')"
   NETWORK_SED=$result
}


netdocker(){
   result=''
   result="$(echo $SERVER_ADDRESS | cut -f1 -d'.')"
   result=$result."$(echo $SERVER_ADDRESS | cut -f2 -d'.')"
   NET_DOCKER=$result
}

reverse
network
network_sed_format
netdocker

prepare_dns(){
   domain_name
   reverse_net
   conf_local
   conf_options
   resolv_conf
}

prepare_dns

echo "******* Executing supervisord"
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
