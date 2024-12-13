# Atividade AWS Docker


![Minha Imagem](./img/projeot.png)


## Descrição da Atividade 

Este projeto tem como objetivo fixar os conhecimentos adquiridos sobre Docker e AWS durante nossa trilha de aprendizagem, trazendo tudo o que estamos estudando sobre aspectos de infraestrutura, configuração e deployment de uma aplicação, containers, e como funciona a AWS. O trabalho envolve a utilização de scripts para automação de tarefas, a implementação de RDS para o banco de dados, a configuração de Load Balancer para balanceamento de tráfego, e a utilização de EFS para armazenamento de arquivos estáticos, tudo em um ambiente na nuvem, com foco em práticas reais de implementação e escalabilidade.
## Índice das Tarefas

1. [Script](#1-script)
   - Configuração e execução do WordPress em contêiner Docker.
   - Testes locais e ajustes no script.

2. [Configuração da Instância EC2](#2-configuração-da-instância-ec2)
   - Criação da instância EC2 com Amazon Linux 2.
   - Inserção do script de automação no campo User Data.

3. [Criação da VPC e Configuração de Rede](#3-criação-da-vpc-e-configuração-de-rede)
   - Criação de VPC.
   - Configuração de sub-redes públicas e privadas.
   - Criação de grupos de segurança.

4. [Criação do RDS (Banco de Dados)](#4-criação-do-rds-banco-de-dados)
   - Criação do RDS MySQL.
   - Configuração de acesso e credenciais.

5. [Deploy da Aplicação WordPress](#5-deploy-da-aplicação-wordpress)
   - Deploy em contêiner.
   - Utilização do RDS para banco de dados MySQL.

6. [Configuração do EFS (Elastic File System)](#6-configuração-do-efs-elastic-file-system)
   - Configuração do EFS para arquivos estáticos do WordPress.

7. [Configuração do Load Balancer (AWS)](#7-configuração-do-load-balancer-aws)
   - Configuração do Load Balancer Classic para distribuição de tráfego.

8. [Testes e Validação](#8-testes-e-validação)
   - Testar a criação da VPC, a configuração do RDS, e a comunicação entre os serviços.
   - Validar a distribuição de tráfego via Load Balancer e a conectividade com o banco de dados no RDS.

---

## Detalhes das Tarefas

### 1. Script
Comecei com essa etapa para entender como funcionaria a execução do WordPress em um contêiner Docker. Realizei testes locais para consolidar melhor o processo. O objetivo do script é configurar a instância com o Docker instalado e, em seguida, iniciar automaticamente a aplicação WordPress. Para garantir que tudo estivesse funcionando corretamente, realizei testes no meu sistema Linux, utilizando o WSL. O teste foi bem-sucedido e, após isso, retirei a imagem do MariaDB do script, pois ela não será utilizada no projeto.

```bash
#!/bin/bash
 
# atualiza os pacotes existentes e instala o Docker
sudo yum -y update
sudo yum install docker -y
 
# habilita e inicia o serviço Docker
sudo systemctl start docker
sudo systemctl enable docker
 
# adiciona o usuário atual ao grupo Docker
sudo usermod -aG docker ec2-user
 
# baixando e instalando o Docker Compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
 
# dando permissão ao binário
sudo chmod +x /usr/local/bin/docker-compose
 
# cria o arquivo docker-compose.yml no diretório do usuário ec2-user
cat <<EOF > /home/ec2-user/docker-compose.yml
services:

  wordpress:
    image: wordpress
    restart: always
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: em criação 
      WORDPRESS_DB_USER: em criação 
      WORDPRESS_DB_PASSWORD: em criação 
      WORDPRESS_DB_NAME: em criação
    volumes:
      - wordpress_data:/var/www/html

volumes:
  wordpress_data:
EOF
 
# indo para o diretório onde o arquivo foi criado
cd /home/ec2-user
 
# executa o docker compose para subir o container no local onde foi criado o arquivo yaml
sudo -u ec2-user /usr/local/bin/docker-compose up -d


```

### 2.**Configuração que foi utilizada na instância EC2 para rodar o script.**
No console da AWS, acessei a seção EC2 para iniciar o processo de criação de uma nova instância.

Configuração da Instância:
- Acessei o Console da AWS e naveguei até a seção **EC2**.
- Iniciei a criação de uma nova instância, selecionando a imagem **Amazon Linux 2 (64-bit)**.
- Adicionei as tags necessárias.
- Escolhi a instância **t2.micro** com **8 GiB de armazenamento** em um volume.
- Na seção **"Detalhes Avançados"**, localizei a opção **User data**.
- No campo **User Data**, inseri o script desenvolvido para automatizar a instalação e configuração de um ambiente Docker na instância EC2, conforme descrito no Script a cima. 


### 3. **Criação da VPC e Configuração de Rede**
   - Criar uma VPC (Virtual Private Cloud) na AWS.
   - Configurar sub-redes públicas e privadas.
   - Criar um grupo de segurança para controlar o acesso à instância e ao banco de dados.

** EM CRIAÇÃO **

### 4. **Criação do RDS (Banco de Dados)**
   - Criar uma instância do RDS utilizando o MySQL.
   - Configurar o RDS para ser acessível a partir das instâncias do WordPress.
   - Definir as credenciais de acesso e as configurações necessárias para o banco de dados.

** EM CRIAÇÃO **

### 5. **Deploy de Aplicação Wordpress**
   - Deploy do Wordpress em container.
   - Utilização do **RDS** para banco de dados MySQL.

** EM CRIAÇÃO **

### 6. **Configuração do EFS (Elastic File System)**
   - Configurar o EFS para armazenar arquivos estáticos do Wordpress.

** EM CRIAÇÃO **

### 7. **Configuração do Load Balancer (AWS)**
   - Configurar o Load Balancer Classic para distribuir o tráfego da aplicação Wordpress.

** EM CRIAÇÃO **

### 8. **Testes e Validação**
   - Testar a criação da VPC, a configuração do RDS, e a comunicação entre os serviços.
   - Validar a distribuição de tráfego via Load Balancer e a conectividade com o banco de dados no RDS.

** EM CRIAÇÃO **



