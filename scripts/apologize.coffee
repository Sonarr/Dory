# Description:
#   Replies to criticism
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot apologize - Spits out an apology

module.exports = (robot) ->
  robot.respond /apologize/i, (msg) ->
    apologies = [ "I'm sorry :(",
                "I've been a bad, bad computer",
                "I'll do better next time",
                "Sorry...",
                "What did I do!? :(",
                "Give me another chance!",
                "I am truly sorry",
                "Sure, blame the computer",
                "I do apologize for any inconvenience or alarm",
                "oh god what have I done",
                "uhhh whoops. Sorry",
                "Sigh. I've really done it this time, haven't I?",
                "Aww you know I was just kidding <3",
                "We apologize for the fault in the botscript. Those responsible have been sacked."]
    msg.send msg.random apologies