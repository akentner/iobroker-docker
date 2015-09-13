FROM mhart/alpine-node:latest

RUN apk add --update vim bash

# add build tools
RUN apk add --update make gcc g++ python

# install and configure iobroker
WORKDIR /opt/iobroker

RUN npm cache clean && npm install iobroker --unsafe-perm
ADD scripts/run.sh /opt/iobroker/run.sh
RUN echo $(hostname) >.install_host

# remove build tools
#RUN apk del make gcc g++ python && \
#    rm -rf /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp

EXPOSE 8081

CMD /opt/iobroker/run.sh
#CMD /bin/bash
