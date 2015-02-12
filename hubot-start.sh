#!/bin/sh

export user=$(whoami)
export PATH=$PATH:/home/hudrone/.nvm/v0.10.20/bin

export PORT="9889"
export HUBOT_AUTH_ADMIN="markus101"


cd /home/hudrone/hudrone
cp hubot-scripts-deploy.json hubot-scripts.json

./bin/hubot -a irc
