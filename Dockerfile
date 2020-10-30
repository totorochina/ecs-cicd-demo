#Download base image ubuntu
FROM ubuntu

# Update Software repository
RUN apt-get update
 
# Install python python-pip from ubuntu repository
# RUN apt-get install -y python python-pip unzip && \
#     rm -rf /var/lib/apt/lists/*
RUN apt-get install -y python3 python3-pip unzip && \
    rm -rf /var/lib/apt/lists/*
 
#Define the ENV variable
#ENV nginx_vhost /etc/nginx/sites-available/default
#ENV php_conf /etc/php/7.0/fpm/php.ini
#ENV nginx_conf /etc/nginx/nginx.conf
#ENV supervisor_conf /etc/supervisor/supervisord.conf

#
 
# Enable php-fpm on nginx virtualhost configuration
#COPY default ${nginx_vhost}
#RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_conf} && \
#    echo "\ndaemon off;" >> ${nginx_conf}
 
#Copy supervisor configuration
#COPY supervisord.conf ${supervisor_conf}
 
#RUN mkdir -p /run/php && \
#    chown -R www-data:www-data /var/www/html && \
#    chown -R www-data:www-data /run/php
 
# Volume configuration
#VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]
 
# Configure Services and Port
#COPY start.sh /start.sh
#CMD ["./start.sh"]
 
#EXPOSE 80 443

# Install tornado
RUN pip3 install tornado

# Copy files
RUN mkdir -p /tmp/data/
COPY api.py /tmp/data/

# Start process
CMD ["python3", "/tmp/data/api.py"]

#EXPOSE 9000
EXPOSE 80
#EXPOSE 80
#EXPOSE 80
