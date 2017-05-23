# Description:
#   JR,メトロの運行情報取得
#
# Dependencies:
#   "cheerio-httpcli": "0.6.9"
#
# Configuration:
#   None
#
# Commands:
#   train - yamanote, keihin, tokaido, sobu, nanboku, tozai, yuraku, oedo
#
# Author:
#   yo-yoshida

client = require 'cheerio-httpcli'

urls = {  yamanote:"http://transit.yahoo.co.jp/traininfo/detail/21/0/"
	    , keihin:"http://transit.yahoo.co.jp/traininfo/detail/22/0/"
		, tokaido:"http://transit.yahoo.co.jp/traininfo/detail/27/0/"
		, sobu:"http://transit.yahoo.co.jp/traininfo/detail/40/0/"
		, nanboku:"http://transit.yahoo.co.jp/traininfo/detail/139/0/"
		, tozai:"http://transit.yahoo.co.jp/traininfo/detail/135/0/"
		, yuraku:"http://transit.yahoo.co.jp/traininfo/detail/137/0/"
		, oedo:"http://transit.yahoo.co.jp/traininfo/detail/131/0/"
	   }

getData = (data) ->
	
	#路線名
	lineName = data("h1.title").text()
	
	#<dd class="normal">があると平常運転
	detail_normal = data("dd.normal > p").text()
	#<dd class="trouble">があるとトラブルあり
	detail_trouble = data("dd.trouble > p").text()
	
	if detail_normal == ""
		message = lineName + ":" + detail_trouble
	else
		message = lineName + ":OK"
	
	return message

module.exports = (robot) ->
	robot.hear /train/i, (msg) ->
		cnt = 0	
		message = ""
		for key, value of urls
			client.fetch(value, {}, (err, $, res, body) ->			
				message = message + getData($) + "\n"
				cnt++		
				if cnt is Object.keys(urls).length
					msg.send(message)
			)
		