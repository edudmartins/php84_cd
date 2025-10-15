# Utilizaremos Ubuntu como SO
FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

# Update do linux e instalação de dependências 
RUN apt-get update && apt-get install -y
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:ondrej/php

# Instalação do Apache, PHP, plugins do PHP e softwares necessários
RUN apt-get install -y build-essential \
    nano \
    unzip \
    curl \
    locales \
    apache2 \
    php8.4 \
    php8.4-common \
    php8.4-mysql \
    php8.4-xml \
    php8.4-xmlrpc \
    php8.4-curl \
    php8.4-gd \
    php8.4-imagick \
    php8.4-cli \
    php8.4-dev \
    php8.4-imap \
    php8.4-mbstring \
    php8.4-opcache \
    php8.4-soap \
    php8.4-zip \
    php8.4-intl \
    php8.4-bcmath \
    php8.4-pgsql \
    php8.4-pspell \
    libapache2-mod-php8.4 \
    && apt-get clean 

RUN locale-gen pt_BR.UTF-8

# Instala o Composer para o PHP
RUN cd /usr/local/lib/ && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Instala o CA Certificates para futura configuração SSL
RUN apt-get install --reinstall ca-certificates -y

# Seta as permissões da pasta src
RUN chown $USER:www-data -R /var/www
RUN chmod u=rwX,g=srX,o=rX -R /var/www
RUN find /var/www -type d -exec chmod g=rwxs "{}" \;
RUN find /var/www -type f -exec chmod g=rws "{}" \;

# Ativa Apache mod_rewrite
RUN a2enmod rewrite
RUN a2enmod actions

# Altera AllowOverride de None para All
RUN sed -i '170,174 s/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Inicia o Apache
RUN service apache2 restart

# Expõe as portas necessárias
EXPOSE 80 8080 3306

# Roda o apache fulltime
ENTRYPOINT ["apache2ctl", "-D", "FOREGROUND"]
