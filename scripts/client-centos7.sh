#!/bin/bash

# -- Correção de Timezone --
rm -Rf /etc/localtime
ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# -- Instalaçãp de programas necessários --
yum install perl -y -y
yum install wget -y

# -- Download do agente GLPI Inventory --
wget "https://github.com/glpi-project/glpi-agent/releases/download/1.4/glpi-agent-1.4-linux-installer.pl"

# -- Execuçãoo do agente
sudo perl glpi-agent-1.4-linux-installer.pl -s=http://192.168.100.140/glpi/front/inventory.php --install

# -- Ativa e reinicia serviço GLPI Inventori
systemctl enable glpi-agent
service glpi-agent restart
sleep 5

# -- Execução do envio do inventário para o servidor GLPI
perl glpi-agent-1.4-linux-installer.pl --runnow