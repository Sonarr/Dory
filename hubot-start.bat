SET PORT="9889"
DEL .hubot_history

COPY hubot-scripts-dev.json hubot-scripts.json /Y

node .\node_modules\coffeescript\bin\coffee .\node_modules\hubot\bin\hubot -n dory
