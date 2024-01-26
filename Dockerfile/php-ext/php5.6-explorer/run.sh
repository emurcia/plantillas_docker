#!/bin/bash

echo "Creando el usuario admin"
useradd -m -s /bin/bash admin
echo "admin:$PASSWORD_ADMIN_SSH" | chpasswd --md5
#agregando al usuario admin al grupo sudo
usermod -aG sudo admin

echo "Creando el usuario user"
useradd -m -s /bin/bash user
echo "user:$PASSWORD_USER_SSH" | chpasswd --md5

echo "Habilitando puerto de escucha adicional 8080"
echo "Listen 8080" >>  /etc/apache2/ports.conf

echo "Habilitando puerto de escucha adicional 8080"
echo "Listen 8080" >>  /etc/apache2/ports.conf

echo "Iniciando la instalacion de kodExplorer"
mkdir /var/www/explorador
cd /var/www/explorador/
wget https://github.com/kalcaddle/KODExplorer/archive/master.zip
unzip master.zip
cd KodExplorer-master/
mv * /var/www/explorador/

chmod -Rf 777 /var/www/explorador
chmod -Rf 777 /var/www/html

echo "Este usuario (user) solamente tiene acceso a: /home/user/  y  /var/www/html/" >> /home/user/info.md
echo "Este usuario (admin) pertenece al grupo sudo" >> /home/admin/info.md

cd /var/www/html/

/bin/bash

service ssh start
service apache2 restart

rm -rf /usr/local/bin/run.sh
