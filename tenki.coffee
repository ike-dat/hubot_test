# Description:
#   東京都の降雨レーダー＆千代田区の3時間天気予報(tenki.jp)
#
# Dependencies:
#   "cheerio-httpcli": "0.6.9"
#
# Configuration:
#   None
#
# Commands:
#   tenki - chiyoda-ku's weather
#
# Author:
#   yo-yoshida

client = require 'cheerio-httpcli'

#千代田区
url = "http://www.tenki.jp/forecast/3/16/4410/13101.html"

#稚内
#url = "http://www.tenki.jp/forecast/1/1/1100/1214.html"

#与那国町
#url = "http://www.tenki.jp/forecast/10/50/9420/47382.html"

radarUrl = "http://www.tenki.jp/radar/3/16/"

days = ['日', '月', '火', '水', '木', '金', '土']

addDays = (add) ->
	
	now = new Date()
	baseSec = now.getTime()
	calcSec = baseSec + add * 86400000
	now.setTime(calcSec)	
	return now
	
getDayString = (date) ->
	
	m = date.getMonth() + 1
	d = date.getDate()
	w = date.getDay()
	
	if m < 10
		m = '0' + m
		
	if d < 10
		d = '0' + d
	
	DayString = m + "/" + d + "(" + days[w] + ")"
	
	return DayString

getData = (data) ->
	
	message = ""
	
	# 1～3行目：今日/明日/明後日の天気
	for i in [0..2]
		
		time = addDays(i)
		day = getDayString(time)
		
		# 0:3時, 1:6時, 2:9時, 3:12時, 4:15時, 5:18時, 6:21時, 7:24時
		for j in [0..7]
			
			# 0～23(0-7:今日, 8-15:明日, 16-23:明後日)
			idx = i * 8 + j 
			
			# <tr class="weather">の子の<p>
			p = data("tr.weather p").eq(idx)
			weather = p.text()
			
			# class="past"は今日の過ぎた時間の天気
			if p.hasClass('past')
				day = day + ":heavy_minus_sign:"
			else if /晴/.test(weather)
				# 夜間は月マーク
				if j is 0 || j > 5
					day = day + ":crescent_moon:"
				# 昼間は太陽マーク
				else
					day = day + ":sunny:"
			else if /曇/.test(weather)
				day = day + ":cloud:"
			else if /雨/.test(weather)
				day = day + ":umbrella:"
			else if /雪/.test(weather)
				day = day + ":snowman:"
			else if /みぞれ/.test(weather)
				day = day + ":snowflake:"
			else
				day = day + ":question:"
				#day = day + data("tr.weather p").eq(i).text() + " "
			
			# 気温 j=1が6時、j=3が12時の気温をそれぞれ最低・最高気温として決めうち
			if j is 1
				tempL = " L:" + data("tr.temperature span").eq(idx).text()
			else if j is 3
				tempH = " H:" + data("tr.temperature span").eq(idx).text()
		
		# 1日分
		message = message + day + tempH + tempL + "\n"
	
	return message

module.exports = (robot) ->
	robot.hear /tenki/i, (msg) ->
		client.fetch(url, {}, (err, $, res, body) ->			
			msg.send(getData($))
		)
		
		client.fetch(radarUrl, {}, (err, $, res, body) ->
			src = $('#radar_image_entries').attr('src')
			msg.send(src)
		)
		
		