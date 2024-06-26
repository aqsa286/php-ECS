# Use the official PHP image with Apache
FROM php:8.1-apache

# Install necessary system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        libpng-dev \
        libjpeg-dev \
        libwebp-dev \
        zlib1g-dev \
        libxpm-dev \
        libfreetype6-dev \
        libonig-dev \
    && rm -rf /var/lib/apt/lists/*

# Configure GD extension for PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql mbstring

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Ensure the necessary permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Run Apache in the foreground
CMD ["apache2-foreground"]
