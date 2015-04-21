require 'net/http'
desc "get games from Applift HO and add to DB"
task :get_HO_applift_games => :environment do 
	puts "starting task..."
	api_uri = URI "http://api.hasoffers.com/Apiv3/json?NetworkId=hitfox&Target=Affiliate_Offer&Method=findAll&api_key=a83c0b7a877ce4296e7ae9d38f5ce667ae6e70ffb77524747f74694bd06081a5&sort%5Bname%5D=asc"
	response = Net::HTTP.start(api_uri.host, api_uri.port) do |http|
	  request = Net::HTTP::Get.new api_uri.request_uri
	  http.request request
	end
	response_body = JSON.parse response.body
	body_length = response_body["response"]["data"].length
	preview_url = response_body["response"]["data"]["919"]["Offer"]["preview_url"]
	puts preview_url
	bundle_id = preview_url.match(/\/id([^\/.]*)\?mt/)
	puts bundle_id[1]
	puts body_length
	puts response_body["response"]["data"].last
	for i in (919..919)
		if response_body["response"]["data"]["#{i}"]
			preview = response_body["response"]["data"]["#{i}"]["Offer"]["preview_url"]
			bundle_id = preview.match(/\/id([^\/.]*)\?mt/)[1]
			game_name = response_body["response"]["data"]["#{i}"]["Offer"]["name"]
			if Game.find_by(bundle_id: bundle_id)
				i = i+1
			else
				puts game_name
			end
		else
			i = i+1
		end
	end


		#game_indexes = (0..(body_length-1)).to_a.sort{rand() - 0.5}[0..5]
		# for i in (0..body_length)
		# 	Game.create(game_name: response_body[i]["creatives"]["title"],
		# 		platform: response_body[i]["app_details"]["platform"],				
		# 		bundle_id: response_body[i]["app_details"]["bundle_id"],
		# 		in_db: true,
		# 		english_vid: response_body[i]["creatives"]["video_url"],
		# 		landscape: response_body[i]["creatives"]["banner_url"],
		# 		square_banner: response_body[i]["creatives"]["standard_banner_url"],
		# 		#icon: response_body[i]["creatives"]["icon_url"],
		# 		english_promo: response_body[i]["creatives"]["description"])
		# 	puts response_body[i]["creatives"]["title"]
		# end
	puts "task finished"
end