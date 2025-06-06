ARG BASE_IMAGE
FROM ${BASE_IMAGE}

LABEL Author="James Schwan  <james@schwan.us>"

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get install -y apache2-utils && \
    apt-get install -y subversion && \
    apt-get install -y libapache2-mod-svn && \
    apt-get install -y libapache2-mod-perl2 && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get -y autoremove --purge

# Setup the websites
RUN echo "IncludeOptional /var/www/conf/*.conf" >> /etc/apache2/sites-available/sites.conf && \
    a2ensite sites && \
    a2enmod rewrite && \
    a2enmod cgi && \
    a2enmod authz_groupfile && \
    a2dissite 000-default && \
    a2dissite default-ssl

VOLUME ["/var/www"]

EXPOSE 80

#HEALTHCHECK --interval=5m --timeout=3s CMD curl --fail http://schwan.us || exit 1

ENTRYPOINT [ "/usr/sbin/apache2ctl" ]

CMD [ "-D", "FOREGROUND" ]

