require 'net/http'
desc "get games from Applift HO and add to DB"
task :get_HO_applift_games => :environment do 
	puts "starting task..."
	api_uri = URI "http://api.hasoffers.com/Apiv3/json?NetworkId=hitfox&Target=Offer&Method=findAll&NetworkToken=NETPpPAhSoFvcEVRFbN3XLXkvlqzTs&filters%5Bis_private%5D%5BFALSE%5D=1&filters%5Bstatus%5D=active"
	response = Net::HTTP.start(api_uri.host, api_uri.port) do |http|
	  request = Net::HTTP::Get.new api_uri.request_uri
	  http.request request
	end
	response_body = JSON.parse response.body
	response_array = response_body["response"]["data"].values
	body_length = response_body["response"]["data"].values.length
	preview_url = response_body["response"]["data"]["919"]["Offer"]["preview_url"]
	puts preview_url
	bundle_id = preview_url.match(/\/id([^\/.]*)\?mt/)
	puts bundle_id[1]
	puts body_length
	# puts response_array[0]
	# puts response_array[0]["Offer"]["preview_url"]
	#last_game = response_body["response"]["data"].values.last
	#puts last_game["offer"]
	#last_id = last_game["id"]
	#puts last_id

	for i in (0..(response_array.length - 1))
			# preview = response_array[i]["Offer"]["preview_url"]
			# bundle_id = preview.match(/\/id([^\/.]*)\?mt/)[1]
			# game_name = response_array[i]["Offer"]["name"]
			# if Game.find_by(bundle_id: bundle_id)
			# 	i = i+1
			# else
			# 	puts game_name
			# end
		#puts response_array[i]["Offer"]["preview_url"]
		preview = response_array[i]["Offer"]["preview_url"]
		#bundle_id = preview.match(/\/id([^\/.]*)\?mt/)
		game_name = response_array[i]["Offer"]["name"]
		if preview.match(/\/id([^\/.]*)\?mt/)
			bundle_id = preview.match(/\/id([^\/.]*)\?mt/)
			if Game.find_by(bundle_id: bundle_id[1])
				i = i +1
			else
				Game.create(game_name: game_name, platform: "iOS", bundle_id: bundle_id, in_db: false)
				puts bundle_id[1]
				puts response_array[i]["Offer"]["name"]
			end
			#example bundle ids: https://play.google.com/store/apps/details?id=air.com.playtika.slotomania
			#https://play.google.com/store/apps/details?id=com.nexon.sjhg&hl=ko
		#else if preview.match(/\/id([^\/.]*)\?mt/)
		else
			#puts preview
			i = i + 1
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