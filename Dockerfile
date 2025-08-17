FROM debian:stable-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq -y update && \
    apt-get -qq -y full-upgrade && \
    apt-get -qq -y install icecast2 python3-pip sudo cron-apt && \
    apt-get -y autoclean && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN chown -R icecast2 /etc/icecast2 && \
    touch /var/log/icecast2/access.log && \
    touch /var/log/icecast2/error.log && \
    chmod 777 /var/log/icecast2/access.log && \
    chmod 777 /var/log/icecast2/error.log && \
    sed -i 's/ -d//' /etc/cron-apt/action.d/3-download

COPY ./start.sh /start.sh
RUN chmod +x /start.sh

COPY ./etc /etc

EXPOSE 8000
VOLUME ["/config", "/var/log/icecast2", "/etc/icecast2"]
CMD ["/start.sh"]
