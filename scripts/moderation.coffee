# Description:
#   Channel moderator helper
#
# Author:
#   Taloth

module.exports = (robot) ->
  robot.hear /allah is doing/i, (msg) ->
    if allowKickBan(msg)
      robot.bot.send "msg", "ChanServ", "KICK", msg.message.room, msg.message.user.name
      msg.send 'Ow wait, I remember that one!'

allowKickBan = (msg) =>
  if msg.message.room not in ['#sonarr']
    return false
  if not /^Guest_/i.test(msg.message.user.name)
    return false
  return true