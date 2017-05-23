# Description:
#   Wikipedia
#
# Dependencies:
#   "cheerio-httpcli": "0.6.9"
#
# Configuration:
#   None
#
# Commands:
#   wiki <query> - Wikipedia
#
# Author:
#   yo-yoshida

client = require 'cheerio-httpcli'

baseurl = "https://ja.wikipedia.org/w/api.php?action=query&format=xml&prop=extracts&redirects=1&exchars=400&explaintext=1&titles="

module.exports = (robot) ->
	robot.hear /wiki (.*)/i, (msg) ->
		keyword = encodeURIComponent msg.match[1]
		client.fetch(baseurl + keyword, {}, (err, $, res, body) ->
			message = $("extract").text()
			msg.send(message)
		)
