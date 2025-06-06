ARG BASE_IMAGE
FROM ${BASE_IMAGE}

LABEL  Author="James Schwan  <james@schwan.us>"

# Install packages
RUN apt-get update && \
    apt-get install -y telnet && \
    apt-get install -y apache2 && \
    apt-get install -y apache2-utils && \
    apt-get install -y libapache2-mod-python && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get -y autoremove --purge

# Setup the website
COPY site.conf /etc/apache2/sites-available/site.conf
RUN a2ensite site && \
    a2enmod cgi && \
    a2dissite 000-default && \
    a2dissite default-ssl

# Copy data for the website
#COPY rpc3.tar.gz /tmp/
#RUN cd /var/www && tar -xzf /tmp/rpc3.tar.gz
COPY src/ /var/www/rpc3/
RUN chmod +x /var/www/rpc3/*.py

# .credentials file with one line: 172.16.0.1:user:pass:172.16.0,172.17.0
# Target IP : username : pass : comma seperated list of allowable access ranges
COPY .credentials /var/www/rpc3

EXPOSE 80

ENTRYPOINT [ "/usr/sbin/apache2ctl" ]

CMD [ "-D", "FOREGROUND" ]
