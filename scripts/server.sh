#!/bin/bash
## -- Ajustando horário --
rm -Rf /etc/localtime
ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

## -- Instalação de serviços --
apt update
apt -y install mariadb-server
apt -y install curl
apt -y install apache2 libapache2-mod-php php-{soap,cas,apcu,curl,gd,imap,ldap,mysql,xmlrpc,xml,mbstring,bcmath,intl,zip,bz2}

# -- Configuração Web Server --
echo -e "<Directory \"/var/www/html/glpi\">\nAllowOverride All\n</Directory>" > /etc/apache2/conf-available/glpi.conf
a2enconf glpi.conf
systemctl reload apache2

# -- Configurção do banco de dados --
mysql -e "create database glpi_db character set utf8"
mysql -e "create user 'glpi_db'@'localhost' identified by 'P@ssglp1DB'"
mysql -e "grant all privileges on glpi_db.* to 'glpi_db'@'localhost' with grant option";
#mysql -e "create user 'relatorio'@'%' identified by 'relatorio'"
#mysql -e "grant all privileges on glpi_db.* to 'relatorio'@'%' with grant option";

# Habilitando acesso remoto ao banco de dados
#sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf
#systemctl restart mariadb

# -- Download do GLPI e extração dos arquivos --
wget -O- https://github.com/glpi-project/glpi/releases/download/10.0.6/glpi-10.0.6.tgz | tar -zxv -C /var/www/html/

# -- Configuração de acesso e segurança --
chown -vRf www-data:www-data /var/www/html/glpi
find /var/www/html/glpi -type d -exec chmod 755 {} \;
find /var/www/html/glpi -type f -exec chmod 644 {} \;

# -- Instalação do GLPI via Console --
php /var/www/html/glpi/bin/console glpi:database:install --db-host='localhost' --db-name='glpi_db' --db-user='glpi_db' --db-password='P@ssglp1DB' --default-language='pt_BR' --quiet

# -- Remove arquivo de instalação --
rm -Rf /var/www/html/glpi/install/install.php

# -- Ajuste de acessos ao diretório de arquivos --
chown -vRf www-data:www-data /var/www/html/glpi/files