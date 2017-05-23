# Description:
#   cat me is the most important thing in your life
#   Interacts with The Cat API. (http://thecatapi.com/)
#
# Dependencies:
#   "cheerio-httpcli": "0.6.9"
#
# Configuration:
#   None
#
# Commands:
#   hubot cat me - Receive a cat
#
# Author:
#   tenten0213(original), yo-yoshida(changed)

client = require 'cheerio-httpcli'
url = "http://thecatapi.com/api/images/get?format=xml&type=jpg&size=med"

module.exports = (robot) ->
	robot.respond /cat me/i, (msg) ->
		client.fetch(url, {}, (err, $, res, body) ->
			image = $("url").text()
			
			# http://dd.media.tumblr.com/ -> http://media.tumblr.com
			media = image.replace(/\d+\.media/, "media")
			console.log(media)
			
			msg.send(media)
		)