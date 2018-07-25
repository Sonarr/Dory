# Description:
#   Channel moderator helper
#
# Author:
#   Taloth
#
# Guest_84753 (779dc90c@gateway/web/cgi-irc/kiwiirc.com/ip.123.123.123.123) has joined #sonarr
# Zathrus804 and other usernames ending with 3 digits, color coding and mentioning multiple users.
#
# 'blog' about freenodegate

module.exports = (robot) ->
  robot.hear /allah is doing/i, (msg) ->
    handlePotentialSpammer msg
  robot.hear /bryanostergaard|encyclopediadramatica/i, (msg) ->
    handlePotentialSpammer msg

handlePotentialSpammer = (msg) =>
  if allowKickBan(msg)
    chanServKickBan msg
  else if allowQuiet(msg)
    chanServQuiet msg

allowQuiet = (msg) =>
  if msg.message.room not in ['#sonarr','#sonarr-test']
    return false
  return true

allowKickBan = (msg) =>
  if not allowQuiet msg
    return false
  if not /^Guest_/i.test(msg.message.user.name) and not /\d{3}$/.test(msg.message.user.name)
    return false
  return true

chanServ = (msg,cmd) =>
  msg.robot.adapter.send {user: {name: "ChanServ"}}, cmd

chanServQuiet = (msg) =>
  msg.robot.adapter.bot.whois msg.message.user.name, (whois) ->
    if whois.host
      chanServ msg, "QUIET #{msg.message.room} *!#{whois.user}@#{whois.host}"

chanServKickBan = (msg) =>
  msg.robot.adapter.bot.whois msg.message.user.name, (whois) ->
    if whois.host
      chanServ msg, "AKICK #{msg.message.room} ADD *!#{whois.user}@#{whois.host} !T 1h"