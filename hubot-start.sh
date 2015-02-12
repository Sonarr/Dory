#!/bin/sh

export user=$(whoami)

export PORT="9889"
export HUBOT_AUTH_ADMIN="markus101"

. ./secrets.sh

cd /home/hubot/hubot
cp hubot-scripts-deploy.json hubot-scripts.json

./bin/hubot -a irc
