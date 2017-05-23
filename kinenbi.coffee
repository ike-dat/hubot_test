# Description:
#   今日の記念日(http://www.kinenbi.gr.jp/)
#
# Dependencies:
#   "cheerio-httpcli": "0.6.9"
#
# Configuration:
#   None
#
# Commands:
#   kinen - today's kinen-bi
#
# Author:
#   yo-yoshida

client = require 'cheerio-httpcli'

url = "http://www.kinenbi.gr.jp/"

getData = (data) ->
	
	message = "今日の記念日-"
			
	#<div class="today_kinenbilist">の子の<a class="winDetail">
	kinenbiAll = data("div.today_kinenbilist a.winDetail").text()
	
	# そのままだと Aの日Bの日Cの日という文字が返ってくるので、分割
	kinenbiList = kinenbiAll.split("の日")
	
	# for文をまわすが、配列の最後の要素が''なのでlength-1ではなくlength-2とする
	for i in [0..kinenbiList.length - 2]
		message = message + kinenbiList[i] + "の日 "
	
	return message

module.exports = (robot) ->
	robot.hear /kinen/i, (msg) ->
		client.fetch(url, {}, (err, $, res, body) ->			
			msg.send(getData($))
		)
		