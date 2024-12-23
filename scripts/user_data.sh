#!/bin/bash


# Atualiza o repositório de pacotes do sistema e instala pacotes necessários para a instalação do Docker
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg

# Cria o diretório onde as chaves GPG do repositório do Docker serão armazenadas
sudo mkdir -p /etc/apt/keyrings

# Baixa a chave GPG oficial do Docker e a salva no diretório criado, dando permissão de leitura para a chave baixada
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Adiciona o repositório oficial do Docker, com a chave GPG para validar os pacotes
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualiza a lista de pacotes novamente
sudo apt-get update -y

# Instala a versão mais recente do Docker e suas dependências
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin nfs-common

# Inicia o serviço Docker no sistema
sudo systemctl start docker

# Adiciona o usuário 'ubuntu' ao grupo Docker para permitir o uso do Docker sem sudo
sudo usermod -aG docker ubuntu

# Atualiza o grupo para garantir que as permissões do Docker sejam aplicadas imediatamente
newgrp docker

# Instala o pacote necessário para trabalhar com sistemas de arquivos NFS
sudo apt install nfs-common -y

# Cria o diretório onde o EFS será montado
sudo mkdir -p /mnt/efs

# Monta o sistema de arquivos EFS (Elastic File System) na pasta /mnt/efs
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport <id-efs>.efs.us-east-1.amazonaws.com:/ /mnt/efs

# Cria o diretório onde os dados do projeto serão armazenados
sudo mkdir -p /projeto

# Criação do arquivo docker-compose.yml
cat <<EOF > /projeto/docker-compose.yml
services:
  wordpress:
    image: wordpress
    restart: always
    ports:
      - 80:80
    environment:
      WORDPRESS_DB_HOST: <endpoint>
      WORDPRESS_DB_USER: <user>
      WORDPRESS_DB_PASSWORD: <Senha>
      WORDPRESS_DB_NAME: <nomebancodedados>
    volumes:
      - /mnt/efs:/var/www/html
EOF
# Inicia o Docker Compose, usando o arquivo docker-compose.yml localizado no diretório /projeto, para subir os containers definidos no arquivo
docker compose -f /projeto/docker-compose.yml up
