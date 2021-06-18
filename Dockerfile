FROM centos:7
RUN yum update -y && yum clean all

# Repository
# EPEL
RUN yum install -y epel-release
# remi
RUN yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

# Install apache
RUN yum install -y httpd

# Install PHP
RUN yum -y install --enablerepo=remi,remi-php74 php php-devel php-mbstring php-pdo php-xml php-gd php-fpm php-mysqlnd php-opcache php-pecl-zip libzip5

# RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# phpDocumentor
RUN composer require --dev phpdocumentor/phpdocumentor

RUN "ServerName localhost" >> /etc/httpd/conf/httpd.conf
RUN "Listen 8080" >> /etc/httpd/conf/httpd.conf

COPY index.html /var/www/html

# Port
EXPOSE 8080

# Httpd start
ENTRYPOINT ["/usr/sbin/httpd", "-DFOREGROUND"]
