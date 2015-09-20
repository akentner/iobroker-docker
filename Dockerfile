FROM mhart/alpine-node:0.12
MAINTAINER Alexander Kentner "akentner@lexsign.de"

RUN apk add --update \
    bash \
    python \
    build-base \
    krb5-dev \


RUN mkdir -p /opt/iobroker \
    && adduser -h /opt/iobroker -s /bin/bash -D iobroker \
    && chown iobroker /opt/iobroker

RUN if [ ! -f "/usr/bin/iobroker" ]; then \
        echo 'node /opt/iobroker/node_modules/iobroker.js-controller/iobroker.js $1 $2 $3 $4 $5' > /usr/bin/iobroker; \
        chmod a+x /usr/bin/iobroker; \
    fi

USER iobroker
ENV HOME /opt/iobroker

# install and configure iobroker
WORKDIR /opt/iobroker

RUN npm cache clean \
    && npm install iobroker

USER root

ADD scripts/run.sh /opt/iobroker/run.sh
RUN echo $(hostname) >.install_host
RUN chmod a+x /opt/iobroker/run.sh

USER iobroker

RUN iobroker add artnet \
    && iobroker add fritzbox \
    && iobroker add hm-rpc \
    && iobroker add hm-rpc \
    && iobroker add hm-rega \
    && iobroker add hue \
    && iobroker add yr \
    && iobroker add mqtt \
    && iobroker add ping \
    && iobroker add pushbullet \
    && iobroker add history \
    && iobroker add ical

RUN iobroker add javascript \
    && iobroker add scenes \
    && iobroker add node-red

RUN iobroker add web \
    && iobroker add icons-addictive-flavour-png \
    && iobroker add icons-mfd-png

RUN iobroker add vis

EXPOSE 8081
EXPOSE 8082
EXPOSE 1880
EXPOSE 8090

CMD /opt/iobroker/run.sh
#CMD /bin/bash
