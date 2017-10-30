+FROM m3hran/baseimage
 +MAINTAINER Martin Taheri <MartinTaheri@gmail.com>
 +
 +
 +ENV ACTIVEMQ_VERSION 5.14.4
 +ENV ACTIVEMQ_HOME /u/apps/activemq
 +ENV ACTIVEMQ_DATA_DIR /u/data/activemq
 +ENV ACTIVEMQ_LOG_DIR /var/log/activemq
 +
 +RUN clean_install.sh python-testtools python-nose python-pip logrotate locales \
 +    && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
 +    && locale-gen en_US.UTF-8 \
 +    && dpkg-reconfigure locales 
 +
 +RUN pip install stomp.py
 +
 +# Install activemq
 +RUN mkdir -p ${ACTIVEMQ_HOME} \
 +    && cd /usr/src \
 +    && wget http://apache.mirrors.ovh.net/ftp.apache.org/dist/activemq/${ACTIVEMQ_VERSION}/apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz \
 +    && tar -xvzf apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz \
 +    && mv apache-activemq-${ACTIVEMQ_VERSION}/* ${ACTIVEMQ_HOME} \
 +    && rm -rf /usr/src/*
 +
 +RUN mkdir -p ${ACTIVEMQ_DATA_DIR} \
 +    && mkdir -p ${ACTIVEMQ_LOG_DIR} \
 +    && groupadd activemq \
 +    && useradd --system --home ${ACTIVEMQ_HOME} -g activemq activemq \
 +    && chown -R activemq:activemq ${ACTIVEMQ_HOME} \
 +    && chown -R activemq:activemq ${ACTIVEMQ_DATA_DIR} \
 +    && chown -R activemq:activemq ${ACTIVEMQ_LOG_DIR} 
 +
 +# Setup logrotate for activemq
 +RUN echo  \
 +    ${ACTIVEMQ_LOG_DIR}/activemq/*.log { \n\
 +    su activemq activemq \n\
 +    daily \n\
 +    missingok \n\
 +    rotate 10 \n\
 +    compress \n\
 +    copytruncate \n\
 +    dateext \n\
 +    dateformat -%Y-%m-%d \n\
 +    }\
 +    >> /etc/logrotate.d/activemq 
 +
 +# Startup activemq with the container
 +COPY bin/activemq_start.sh /etc/my_init.d/activemq_start.sh
 +RUN chmod +x /etc/my_init.d/activemq_start.sh
 +
 +WORKDIR /u/apps
 +
 +# Expose all ports
 +EXPOSE 8161
 +EXPOSE 61616
 +EXPOSE 5672
 +EXPOSE 61613
 +EXPOSE 1883
 +EXPOSE 61614
 +
 +# Expose some folders
 +#VOLUME ["/u/data/activemq"]
 +#VOLUME ["/var/log/activemq"]
 +#VOLUME ["/u/opt/activemq/conf"]
