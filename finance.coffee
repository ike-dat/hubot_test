# Description:
#   IIJに関する株価を表示
#
# Dependencies:
#   "cheerio-httpcli": "0.6.9"
#
# Configuration:
#   None
#
# Commands:
#   stock - IIJ, Amazon, Google, Tencent's stock value
#
# Author:
#   yo-yoshida

client = require 'cheerio-httpcli'

googleFinanceUrl = "https://www.google.com/finance"
codes = ["TYO:3774", "NASDAQ:AMZN", "NASDAQ:GOOG", "HKG:0700"]

getData = (data) ->
	
	#会社名
	company = data("meta[itemprop='name']").attr("content")
	
	#現在の株価
	price = data("meta[itemprop='price']").attr("content")
	
	#前日との差(株価)
	change = data("meta[itemprop='priceChange']").attr("content")
	
	#前日との差(%)
	changePercent = data("meta[itemprop='priceChangePercent']").attr("content")
	
	#通貨単位
	currency = data("meta[itemprop='priceCurrency']").attr("content")
			
	message = company + "\n" + "\t" + price + "(" + change + "," + changePercent + "%) " + currency
	return message

module.exports = (robot) ->
	robot.hear /stock/i, (msg) ->
		message = ""
		cnt = 0	
		for code in codes
			client.fetch(googleFinanceUrl, {q:code}, (err, $, res, body) ->
				message = message + getData($) + "\n"
				cnt++
				if cnt is codes.length
					msg.send(message)
			)
				
		