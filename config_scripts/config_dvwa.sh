#!/bin/bash
echo "CREATE USER 'dvwa'@'%' IDENTIFIED BY 'p@ssw0rd'; GRANT ALL PRIVILEGES ON *.* TO 'dvwa'@'%'; RENAME USER 'root'@'localhost' TO 'root'@'%';FLUSH PRIVILEGES;" > user.sql
chmod 777 user.sql
echo "create database dvwa" > base.sql
chmod 777 base.sql
sudo debconf-set-selections <<< 'mariadb-server mysql-server/root_password password rootpass'
sudo debconf-set-selections <<< 'mariadb-server mysql-server/root_password_again password rootpass'
sudo apt update
sudo apt-get install -y apache2 mariadb-server mariadb-client php php-mysqli php-gd libapache2-mod-php
sudo mysql -u root -prootpass< user.sql
sudo mysql -u root -prootpass< base.sql
sudo rm -f user.sql
sudo rm -f base.sql
sudo apt-get clean
cd /var/www/html
sudo git clone https://github.com/ethicalhack3r/DVWA.git
sudo chmod -R 777 DVWA
sudo sed -i '33s/.*/$_DVWA[ '\''default_security_level'\'' ] = '\''low'\'';/' /var/www/html/DVWA/config/config.inc.php.dist
sudo sed -i '43s/.*/$_DVWA[ '\''disable_authentication'\'' ] = true;/' /var/www/html/DVWA/config/config.inc.php.dist
cd DVWA/config 
sudo cp config.inc.php.dist config.inc.php
sudo sed -i '865s/.*/allow_url_include = On/' /etc/php/8.1/apache2/php.ini
sudo sed -i '503s/.*/display_errors = On/' /etc/php/8.1/apache2/php.ini
sudo sed -i '512s/.*/display_startup_errors = On/' /etc/php/8.1/apache2/php.ini
sudo service apache2 restart && sudo service mysql restart
curl -s -X POST http://tfm2024.northeurope.cloudapp.azure.com/DVWA/login.php -d "username=admin&password=password" -o response.txt
usertoken=$(grep "<input type='hidden' name='user_token' *" response.txt |  sed 's/.*value=//' | tr -dc '[:alnum:]')
curl -s -X POST http://tfm2024.northeurope.cloudapp.azure.com/DVWA/setup.php -d "create_db=Create / Reset Database&user_token="$usertoken""
sudo rm -f response.txt