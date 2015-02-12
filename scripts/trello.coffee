# Description:
#   Create new cards in Trello
#
# Dependencies:
#   "node-trello": "latest"
#
# Configuration:
#   HUBOT_TRELLO_KEY - Trello application key
#   HUBOT_TRELLO_TOKEN - Trello API token
#   HUBOT_TRELLO_LIST - The list ID that you'd like to create cards for
#
# Commands:
#   hubot trello card <name> - Create a new Trello card
#   hubot trello show - Show cards on list
#
# Notes:
#   To get your key, go to: https://trello.com/1/appKey/generate
#   To get your token, go to: https://trello.com/1/authorize?key=<<your key>>&name=Hubot+Trello&expiration=never&response_type=token&scope=read,write
#   Figure out what board you want to use, grab it's id from the url (https://trello.com/board/<<board name>>/<<board id>>)
#   To get your list ID, go to: https://trello.com/1/boards/<<board id>>/lists?key=<<your key>>&token=<<your token>>  "id" elements are the list ids.
#
# Author:
#   carmstrong

module.exports = (robot) ->
  robot.respond /trello card (.*)/i, (msg) ->
    cardName = msg.match[1]
    if not cardName.length
      msg.send "You must give the card a name"
      return
    if not process.env.HUBOT_TRELLO_KEY
      msg.send "Error: Trello app key is not specified"
    if not process.env.HUBOT_TRELLO_TOKEN
      msg.send "Error: Trello token is not specified"
    if not process.env.HUBOT_TRELLO_LIST
      msg.send "Error: Trello list ID is not specified"
    if not process.env.HUBOT_TRELLO_LIST  
      msg.send "Error: Trello Boards are not specified"
    if not (process.env.HUBOT_TRELLO_KEY and process.env.HUBOT_TRELLO_TOKEN and process.env.HUBOT_TRELLO_LIST)
      return
    createCard msg, cardName
    
  robot.respond /trello show/i, (msg) ->
    showCards msg

  robot.respond /trello search (.*)/i, (msg) ->
    searchCards msg, msg.match[1]

  robot.respond /trello(?!\s)/i, (msg) -> 
    msg.send 'https://trello.com/b/MadvFKy4/nzbdrone'

createCard = (msg, cardName) ->
  Trello = require("node-trello")
  t = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)
  t.post "/1/cards", {name: cardName, idList: process.env.HUBOT_TRELLO_LIST}, (err, data) ->
    if err
      msg.send "There was an error creating the card"
      return
    msg.send data.url

showCards = (msg) ->
  msg.send "Getting cards..."
  Trello = require("node-trello")
  t = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)
  t.get "/1/lists/"+process.env.HUBOT_TRELLO_LIST, {cards: "open"}, (err, data) ->
    if err
      msg.send "There was an error showing the list."
      return

    msg.send "Cards in " + data.name + ":"
    msg.send "- " + card.name for card in data.cards

searchCards = (msg, term) ->
  msg.send "Searching..."
  Trello = require("node-trello")
  t = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)
  t.get "/1/search/", {idBoards: process.env.HUBOT_TRELLO_BOARDS, query: term, cards: "open"}, (err, data) ->
    if err
      msg.send "There was an error searching."
      return

    openCards = (card for card in data.cards when card.closed is false)

    if openCards.length > 0
      msg.send "Cards matching '" + term + "':"
      msg.send "- " + card.name + " : " + card.url for card in openCards

    else
      msg.send "No matching cards found for: " + term
      