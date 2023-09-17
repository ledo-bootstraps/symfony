FROM paramah/php:8.1-alpine

ENV DIR /var/www
WORKDIR $DIR

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

#Install Symfony CLI
RUN wget https://get.symfony.com/cli/installer -O - | bash
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

# Copy entrypoint
COPY docker/docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN chmod +x /bin/docker-entrypoint.sh

# Copy application
COPY ./app $DIR

ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
