FROM node:15-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh python make g++ yarn

WORKDIR /app

RUN echo cache1

COPY hubot-start.sh external-scripts.json package.json /app/
COPY bin /app/bin
COPY patches /app/patches
COPY scripts /app/scripts
RUN yarn install

ENTRYPOINT /app/hubot-start.sh
