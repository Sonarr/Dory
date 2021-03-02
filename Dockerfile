FROM node:15-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh python make g++

WORKDIR /app

ADD package.json /app/
RUN npm install

ADD ./ /app/

ENTRYPOINT /app/hubot-start.sh