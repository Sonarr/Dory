# Description:
#   Information about dory
#
# Commands:
#   hubot who are you - Let dory tell you who she is
#
# Author:
#   markus101

module.exports = (robot) ->
  robot.respond /who\sare\syou/i, (msg) ->
    msg.send 'I am dory: http://www.aceshowbiz.com/images/news/finding-nemo-sequel-finding-dory-to-be-released-in-2015.jpg'

  robot.respond /^(hack|update|contribute|edit|smarter)$/i, (msg) ->
    msg.send 'You can help make me smarter: https://github.com/Sonarr/Dory'
