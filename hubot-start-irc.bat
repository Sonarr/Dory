SET PORT="9889"
DEL .hubot_history

CALL secrets.bat

COPY hubot-scripts-dev.json hubot-scripts.json /Y

node .\node_modules\hubot\node_modules\coffee-script\bin\coffee .\node_modules\hubot\bin\hubot -a irc
