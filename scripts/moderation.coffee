# Description:
#   Channel moderator helper
#
# Author:
#   Taloth

module.exports = (robot) ->
  robot.hear /allah is doing/i, (msg) ->
    if allowKickBan(msg)
      chanServQuiet msg

allowKickBan = (msg) =>
  if msg.message.room not in ['#sonarr']
    return false
  if not /^Guest_/i.test(msg.message.user.name)
    return false
  return true

chanServ = (cmd) =>
  robot.bot.send {user: {name: "ChanServ"}}, cmd

chanServQuiet = (msg) =>
  chanServ "QUIET #{msg.message.room} #{msg.message.user.name}"
  #msg.send 'Ow wait, I remember that one!'

chanServKickBan = (msg) =>
  robot.bot.whois msg.message.user.name, (whois) ->
    if whois.host
      chanServ "AKICK #{msg.message.room} ADD *!#{whois.user}@#{whois.host} !T 1h"
      #msg.send 'Ow wait, I remember that one!'
