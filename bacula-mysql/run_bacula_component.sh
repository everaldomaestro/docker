#!/bin/bash
db_type=$1

DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT}
DB_ROOT_USER=${DB_ROOT_USER}
DB_ROOT_PASS=${DB_ROOT_PASS}
DB_BACULA_USER=${DB_BACULA_USER}
DB_BACULA_PASS=${DB_BACULA_PASS}
DB_BACULA_DBNAME=${DB_BACULA_DBNAME}

create_pgpass(){
   if [ ! -e "/root/.pgpass" ]; then
      echo "*Create pgpass"
      echo "${DB_HOST}:${DB_PORT}:${DB_ROOT_USER}:${DB_ROOT_USER}:${DB_ROOT_PASS}" > /root/.pgpass && chmod 0600 /root/.pgpass
      echo "${DB_HOST}:${DB_PORT}:${DB_BACULA_DBNAME}:${DB_ROOT_USER}:${DB_ROOT_PASS}" >> /root/.pgpass
   fi
}

create_tag_db(){
   if [ ! -n "$(cat /etc/bacula/bacula-dir.conf | grep dbaddress)" ]; then
      echo "** Technical Acoxambration :("
      sed -i 's/dbpassword = "bacula"/dbpassword = "bacula"; dbaddress = "db"/' /etc/bacula/bacula-dir.conf
   else
      echo "** Nothing to do :)"
   fi
}

check_db_postgresql(){
   WAIT_TIME=5

   while [ ! "$(psql -U ${DB_ROOT_USER} -p ${DB_PORT} -h ${DB_HOST} ${DB_ROOT_USER} -l -q)" ]; do
      echo "*** PostgreSQL server is not available. Waiting $WAIT_TIME seconds..."
      sleep $WAIT_TIME
   done
}

check_db_mysql(){
   WAIT_TIMEOUT=5

   while [ ! "$(mysqladmin ping -u ${DB_ROOT_USER} -P ${DB_PORT} -h ${DB_HOST} -p${DB_ROOT_PASS} --silent --connect_timeout=5)" ]; do
        echo "**** MySQL server is not available. Waiting $WAIT_TIME seconds..."
        sleep $WAIT_TIME
   done
}

create_userdb_bacula_postgresql(){
   USER_EXISTS=$(echo "SELECT 1 FROM pg_roles WHERE rolname='${DB_BACULA_USER}';" | psql -U ${DB_ROOT_USER} -p ${DB_PORT} -h ${DB_HOST} ${DB_ROOT_USER} -tA)
   if [ -z $USER_EXISTS ]; then
      echo "**** User ${DB_BACULA_USER} not exist. Creating..."
      echo "CREATE USER ${DB_BACULA_USER} WITH PASSWORD '${DB_BACULA_PASS}';" | psql -U ${DB_ROOT_USER} -p ${DB_PORT} -h ${DB_HOST} ${DB_ROOT_USER}
   else
      echo "**** User ${DB_BACULA_USER} exist."
   fi
}

create_userdb_bacula_mysql(){
   USER_EXISTS=$(mysql -u ${DB_ROOT_USER} -p${DB_ROOT_PASS} -P ${DB_PORT} -h ${DB_HOST} --skip-column-names -e "SELECT 1 FROM mysql.user WHERE user = '${DB_BACULA_USER}' AND host = '%';")
   if [ -z $USER_EXISTS ]; then
      echo "**** User ${DB_BACULA_USER} not exist. Creating..."
      mysql -u ${DB_ROOT_USER} -p${DB_ROOT_PASS} -h ${DB_HOST} -P ${DB_PORT} -e "CREATE USER ${DB_BACULA_USER}@'%' IDENTIFIED BY '${DB_BACULA_PASS}';"
   else
      echo "**** User ${DB_BACULA_USER} exist."
   fi
}

create_db_bacula_postgresql(){
   ENCODING="ENCODING 'SQL_ASCII' LC_CTYPE 'C' LC_COLLATE 'C' TEMPLATE template0"
   DB_EXISTS=$(echo "SELECT 1 FROM pg_database WHERE datname='${DB_BACULA_DBNAME}';" | psql -U ${DB_ROOT_USER} -p ${DB_PORT} -h ${DB_HOST} ${DB_ROOT_USER} -tA)
   if [ -z $DB_EXISTS ]; then
      echo "***** Database ${DB_BACULA_DBNAME} not exist. Creating..."
      echo "CREATE DATABASE ${DB_BACULA_DBNAME} $ENCODING;" | psql -U ${DB_ROOT_USER} -p ${DB_PORT} -h ${DB_HOST} ${DB_ROOT_USER}
      echo "ALTER DATABASE ${DB_BACULA_DBNAME} SET datestyle TO 'ISO, YMD'" | psql -U ${DB_ROOT_USER} -p ${DB_PORT} -h ${DB_HOST} ${DB_ROOT_USER}
   else
      echo "***** Database ${DB_BACULA_DBNAME} exist."
   fi
}

create_db_bacula_mysql(){
   DB_EXISTS=$(mysql -u ${DB_ROOT_USER} -p${DB_ROOT_PASS} -P ${DB_PORT} -h ${DB_HOST} --skip-column-names -e "SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME='${DB_BACULA_DBNAME}';")
   if [ -z $DB_EXISTS ]; then
      echo "***** Database ${DB_BACULA_DBNAME} not exist. Creating..."
      /etc/bacula/scripts/create_mysql_database -u ${DB_ROOT_USER} -p$DB_ROOT_PASS -h ${DB_HOST} -P $DB_PORT
   else
      echo "***** Database ${DB_BACULA_DBNAME} exist."
   fi
}

make_tables_postgresql(){
   SCHEMA_EXISTS=$(echo "SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='version'" | psql -U ${DB_ROOT_USER} -p ${DB_PORT} -h ${DB_HOST} ${DB_BACULA_DBNAME} -tA)
   if [ -z $SCHEMA_EXISTS ]; then
      echo "****** Schema of Database ${DB_BACULA_DBNAME} not exist. Creating..."
      /etc/bacula/scripts/make_postgresql_tables -U${DB_ROOT_USER} -h${DB_HOST}
      /etc/bacula/scripts/grant_postgresql_privileges -U${DB_ROOT_USER} -h${DB_HOST}
   else
      echo "****** Schema of Database ${DB_BACULA_DBNAME} exist."
   fi
}

make_tables_mysql(){
   SCHEMA_EXISTS=$(mysql -u ${DB_ROOT_USER} -p${DB_ROOT_PASS} -P ${DB_PORT} -h ${DB_HOST} --skip-column-names -e "SELECT 1 FROM information_schema.TABLES WHERE table_schema='${DB_BACULA_DBNAME}' and table_name='Version';")
   if [ -z $SCHEMA_EXISTS ]; then
      echo "****** Schema of Database ${DB_BACULA_DBNAME} not exist. Creating..."
      /etc/bacula/scripts/make_mysql_tables -u ${DB_ROOT_USER} -p${DB_ROOT_PASS} -h ${DB_HOST} -P ${DB_PORT}
      /etc/bacula/scripts/grant_mysql_privileges -u ${DB_ROOT_USER} -p${DB_ROOT_PASS} -h ${DB_HOST} -P ${DB_PORT}
   else
      echo "****** Schema of Database ${DB_BACULA_DBNAME} exist."
   fi
}

prepare_bacula_db_postgresql(){
   create_pgpass
   create_tag_db
   check_db_postgresql
   #create_userdb_bacula_postgresql
   create_db_bacula_postgresql
   make_tables_postgresql
}

prepare_bacula_db_mysql(){
   create_tag_db
   check_db_mysql
   create_userdb_bacula_mysql
   create_db_bacula_mysql
   make_tables_mysql
}

prepare_bacula_db_$db_type

echo "******* Executing supervisord"
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
