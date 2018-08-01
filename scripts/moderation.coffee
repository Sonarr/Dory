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

class ChanServ
  constructor: (robot) ->

  isOp: (msg) ->
    caller = msg.message.user.name.toLowerCase()
    if caller in ['markus101','taloth','shell']
      return true
    return false

  csMsg: (msg, cmd) ->
    msg.robot.adapter.send {user: {name: "ChanServ"}}, cmd

  csQuiet: (msg, username) ->
    if not username
      username = msg.message.user.name
    msg.robot.adapter.bot.whois username, (whois) =>
      if whois.host
        @csMsg msg, "QUIET #{msg.message.room} *!#{whois.user}@#{whois.host}"

  csKickBan: (msg, username) ->
    if not username
      username = msg.message.user.name
    msg.robot.adapter.bot.whois username, (whois) =>
      if whois.host
        @csMsg msg, "AKICK #{msg.message.room} ADD *!#{whois.user}@#{whois.host} !T 1h"

  csVoice: (msg, username) ->
    if not username
      username = msg.message.user.name
    msg.robot.adapter.bot.whois username, (whois) =>
      if whois.host
        @csMsg msg, "VOICE #{msg.message.user.room} #{username}"

class AutoVoice extends ChanServ
  constructor: (@robot) ->
    super(robot)
    @loaded = false
    @autovoice_delay_msec = -1
    robot.brain.on 'loaded', =>
      if not @loaded
        @loaded = true
        @autovoice_delay_msec = @robot.brain.get('AUTO_VOICE_DELAY') || -1
        console.log "Loaded AutoVoiceDelay = #{@autovoice_delay_msec} ms from brain"

  register: (robot) ->
    robot.enter (msg) =>
      @userEnter msg
    robot.hear /autovoice me/i, (msg) =>
      @autoVoiceUser msg, msg.message.user.name
    robot.hear /autovoice user (.*)/i, (msg) =>
      @autoVoiceUser msg, msg.match[1]
    robot.hear /autovoice delay (\d+)/i, (msg) =>
      @setAutoVoiceDelay msg, msg.match[1]

  userEnter: (msg) ->
    callback = => @csVoice msg
    if @autovoice_delay_msec >= 0
      setTimeout callback, @autovoice_delay_msec

  autoVoiceUser: (msg, userName) ->
    if @isOp(msg)
      @csVoice msg, userName

  setAutoVoiceDelay: (msg, delay_msec) ->
    if delay_msec <= 0
      delay_msec = -1
    if @isOp(msg)
      @autovoice_delay_msec = delay_msec
      @robot.brain.set('AUTO_VOICE_DELAY', delay_msec)
      if delay_msec > 0
        msg.send "Set AutoVoice delay to #{delay_msec} ms"
      else
        msg.send "Disabled AutoVoice"
    else
      msg.send "Who are you, #{msg.message.user.name}?"

class SpammerHandler extends ChanServ
  constructor: (robot) ->
    super(robot)

  register: (robot) ->
    robot.hear /allah is doing/i, (msg) =>
      @handlePotentialSpammer msg
    robot.hear /wiliampitcock|bryanostergaard|encyclopediadramatica/i, (msg) =>
      @handlePotentialSpammer msg

  handlePotentialSpammer: (msg) ->
    if @allowKickBan(msg)
      @csKickBan msg
    else if @allowQuiet(msg)
      @csQuiet msg

  allowQuiet: (msg) ->
    if msg.message.room not in ['#sonarr','#sonarr-test']
      return false
    return true

  allowKickBan: (msg) ->
    if not @allowQuiet msg
      return false
    if not /^Guest_/i.test(msg.message.user.name) and not /\d{3}$/.test(msg.message.user.name)
      return false
    return true

module.exports = (robot) ->
  autovoice = new AutoVoice(robot)
  autovoice.register robot
  spammers = new SpammerHandler(robot)
  spammers.register robot


