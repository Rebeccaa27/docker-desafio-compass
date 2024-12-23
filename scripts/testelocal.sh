#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl

sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc


echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y


sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


sudo systemctl start docker
sudo usermod -aG docker $USER  

sudo mkdir -p /projeto && cd /projeto


cat <<EOF > docker-compose.yml
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    restart: always
    ports:
      - "8080:80" 
    environment:
      WORDPRESS_DB_HOST: mariadb:3306  
      WORDPRESS_DB_NAME: wordpress_db 
      WORDPRESS_DB_USER: user  # Usuário do banco de dados
      WORDPRESS_DB_PASSWORD: password  
    volumes:
      - wordpress_data:/var/www/html  
    depends_on:
      - mariadb  # Espera o serviço mariadb ser iniciado primeiro

  mariadb:
    image: mariadb:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword  
      MYSQL_DATABASE: wordpress_db  
      MYSQL_USER: user 
      MYSQL_PASSWORD: password 
    volumes:
      - mariadb_data:/var/lib/mysql  

volumes:
  wordpress_data: 
  mariadb_data: 
EOF

sudo docker compose up -d
