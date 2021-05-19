# Description:
#   Receive Webhooks from TC and announce branch and build number
#
# Configuration:
#   None
#
# Author:
#   markus101

url           = require('url')
querystring   = require('querystring')
branches = [ 'main', 'develop', 'v2' ]

module.exports = (robot) ->
  robot.router.post "/#{robot.name}/teamcity", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)
    data = req.body
    room = query.room || '#hudrone'

    params = {}

    params[param.name] = param.value for param in data.build.extraParameters

    if params.branch in branches
      robot.messageRoom room, 'New version of Sonarr: ' + params.version + ' (' + params.branch + ')'

    console.log param.name + " : " + param.value for param in data.build.extraParameters

    res.send 'OK'
