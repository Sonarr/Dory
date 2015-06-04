# Description:
#   Get information about drone from service's API
#
# Commands:
#   hubot user count - get rolling 2-day count
#
# Author:
#   markus101

services_root = 'http://services.sonarr.tv'
moment = require('moment');
color = require('irc-colors');

module.exports = (robot) ->
  robot.respond /user count/i, (msg) ->
    count msg

  robot.respond /ios/i, (msg) ->
    ios msg

  robot.respond /latest(.*)/i, (msg) ->
    latest_branch msg, msg.match[1]

  robot.respond /(?:changes|changelog)(.*)/i, (msg) ->
    changes_branch msg, msg.match[1]

  robot.respond /(hello|hi|hey)/i, (msg) ->
    hello msg

  robot.respond /eta/i, (msg) ->
    eta msg

  robot.respond /log(\s|\-)?files/i, (msg) ->
    msg.send 'https://github.com/Sonarr/Sonarr/wiki/Log-Files'

  robot.respond /naming|scene nam(?:e|ing)|scene/i, (msg) ->
    msg.send 'https://github.com/Sonarr/Sonarr/wiki/FAQ#why-cant-nzbdrone-import-episode-files-for-series-x--why-cant-nzbdrone-find-releases-for-series-x'

  robot.respond /wiki/i, (msg) ->
    msg.send 'https://github.com/Sonarr/Sonarr/wiki/'

  robot.respond /faq/i, (msg) ->
    msg.send 'https://github.com/Sonarr/Sonarr/wiki/FAQ'

  robot.respond /(release\s)?branches/i, (msg) ->
    msg.send 'https://github.com/Sonarr/Sonarr/wiki/Release-Branches'

  robot.respond /(needo)/i, (msg) ->
    msg.send 'Oh him? He\'s special.'

  robot.respond /(calendar)/i, (msg) ->
    msg.send 'https://forums.sonarr.tv/t/sonarr-now-with-tvdb/3314'

  robot.respond /works/i, (msg) ->
    msg.send 'http://www.wiliam.com.au/content/upload/blog/worksonmymachine.jpg'

  robot.respond /(blame someone)$/i, (msg) ->
    blame_someone msg

count = (msg) ->

  msg.send 'Current user count:'

  msg.http(services_root + '/v1/client/recent/2')
    .header('Accept', 'application/json')
    .get() (err, res, body) ->

      data = JSON.parse(body)
      result = (item for item in data when item.branch is 'master' or item.branch is 'develop')

      msg.send item.branch + ': ' + item.count for item in result

ios = (msg) ->
  msg.send 'Did you mean Android? https://play.google.com/store/devices'

latest_branch = (msg, branch) ->

  branch = branch.toLowerCase().replace /^\s+|\s+$/g, ""

  if not branch.length
    for branch in ['master', 'develop']
      do (branch) ->
        get_latest_update msg, branch

  else
    get_latest_update msg, branch

changes_branch = (msg, branch) ->

  branch = branch.toLowerCase().replace /^\s+|\s+$/g, ""

  if not branch.length
    for branch in ['develop']
      do (branch) ->
        get_latest_changes msg, branch

  else
    get_latest_changes msg, branch

latest = (msg) ->

  branches = [ 'master', 'develop' ]

  for branch in branches
    do (branch) ->
      get_latest_update msg, branch

hello = (msg) ->
  sender_name = msg.message.user.name.toLowerCase()

  if sender_name is 'markus101'
    msg.send 'Hello master'
    return

  if sender_name is 'diviance'
    msg.send 'Hello #1 complainer, Diviance'
    return

  msg.send 'Hello ' + msg.message.user.name

eta = (msg) ->
  eta_replies = [
    "Hopefully soon, otherwise later.",
    "6 to 8 weeks",
    "Soon™",
    "Ask me again later.",
    "One day... I hope"]
  msg.send msg.random eta_replies

blame_someone = (msg) ->
  blamer = msg.message.user.name
  if blamer in [ 'needo' ]
    msg.send 'Weren\'t you special?'
    return
  blamees =
    'dory'     : 'dory'
    'markus101': 'markvs101'
    'kayone'   : 'kay0ne'
    'Taloth'   : 'Ta1oth'
    'Nelluk'   : 'N31luk'
    'NMe84'    : 'NMa84'
    'xelra'    : 'xe1ra'
  blamee = msg.random (leet for name,leet of blamees when name isnt blamer)
  if blamee == "dory"
    blame_quote_replies = [
      'Sorry, blame whom for what? I suffer from short term memory loss.',
      'Sorry, blame whom for what? I suffer from short term memory loss.',
      'A man can fail many times, but he isn\'t a failure until he begins to blame somebody else.']
    msg.send msg.random blame_quote_replies
    return
  blame_replies = [
    'It was all ' + blamee + '\'s fault!',
    'w/e, just blame ' + blamee,
    'Must\'ve been ' + blamee,
    'I suggest it was ' + blamee + ', in the Library, with the Candlestick.']
  msg.send msg.random blame_replies
  
# internal/non-response

get_latest_update = (msg, branch) ->

  msg.http(services_root + '/v1/update/' + branch)
   .header('Accept', 'application/json')
   .get() (err, res, body) ->

      data = JSON.parse(body)
      date = ' (' + moment(data.updatePackage.releaseDate).utc().format('YYYY-MM-DD HH:mm') + ' UTC)'
      msg.send 'The latest release for ' + branch + ' is ' + data.updatePackage.version + color.lightgrey(date)

get_latest_changes = (msg, branch) ->

  msg.http(services_root + '/v1/update/' + branch)
   .header('Accept', 'application/json')
   .get() (err, res, body) ->

      data = JSON.parse(body)
      date = ' (' + moment(data.updatePackage.releaseDate).utc().format('YYYY-MM-DD HH:mm') + ' UTC)'

      changes = []
      if data.updatePackage.changes
        for change in data.updatePackage.changes.new
          changes.push 'New: ' + change
        for change in data.updatePackage.changes.fixed
          changes.push 'Fixed: ' + change
         
      if not changes.length
        msg.send 'Release ' + branch + ' ' + data.updatePackage.version + color.lightgrey(date) + ' is a maintenance release.'
        return

      msg.send 'Changelog for release ' + branch + ' ' + data.updatePackage.version + color.lightgrey(date) + ':'

      more = changes.splice(3)
      for change in changes
        msg.send change
      if more.length == 1
        msg.send more[0]
      else if more.length
        msg.send 'and ' + more.length + ' more'