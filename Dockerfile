FROM php:8.2.5-apache

# Install GIT
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

# Clone the repository
RUN git clone https://github.com/DeylerAF/portfolio.git /var/www/html

EXPOSE 80

# Install required libraries and PHP extensions
RUN apt-get update \
    && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install redis \
    && pecl install xdebug \
    && docker-php-ext-enable redis xdebug


# Install required libraries for Composer
RUN apt-get update && \
    apt-get install -y zip unzip && \
    rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql

# Set recommended PHP.ini settings
RUN { \
    echo 'upload_max_filesize=100M'; \
    echo 'post_max_size=100M'; \
    echo 'max_execution_time=600'; \
    echo 'date.timezone=UTC'; \
    } > /usr/local/etc/php/conf.d/recommended.ini
