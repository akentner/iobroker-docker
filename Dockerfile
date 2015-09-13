FROM mhart/alpine-node:4
MAINTAINER Alexander Kentner "akentner@lexsign.de"

RUN apk add --update vim bash

RUN mkdir -p /opt/iobroker && \
    adduser -h /opt/iobroker -s /bin/bash -D iobroker

ENV HOME /opt/iobroker

# add build tools
RUN apk add --update make gcc g++ python

USER iobroker

# install and configure iobroker
WORKDIR /opt/iobroker

RUN npm cache clean && npm install iobroker --unsafe-perm
ADD scripts/run.sh /opt/iobroker/run.sh
RUN echo $(hostname) >.install_host

USER root
RUN chmod a+x /opt/iobroker/run.sh && \
    cp /opt/iobroker/node_modules/iobroker/install/iobroker /usr/bin/ && \
    chmod 777 /usr/bin/iobroker

# remove build tools
#RUN apk del make gcc g++ python && \
#    rm -rf /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp

EXPOSE 8081

USER iobroker
CMD /opt/iobroker/run.sh
#CMD /bin/bash

