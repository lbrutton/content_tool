require 'net/http'
desc "fill database with bulk API apps, cross-check with offers from HasOffers, then fill empty creative slots"
task :main_task => :environment do 
	puts "starting task..."
	# get games from bulk API
	api_uri = URI "http://bulk.applift.com/api/bulk/v1/promotions?app_token=cc2a5ccfbfb53107ae12cb908c2b8799c81556ba5f12cc3fe61fe96606a80210"
	response = Net::HTTP.start(api_uri.host, api_uri.port) do |http|
	  request = Net::HTTP::Get.new api_uri.request_uri
	  http.request request
	end
	response_body = JSON.parse response.body
	Rake::Task['db:reset'].invoke
	body_length = response_body.length
	# add those games to DB
		for i in (0..body_length-1)
			Game.create(game_name: response_body[i]["creatives"]["title"],
				platform: response_body[i]["app_details"]["platform"],				
				bundle_id: response_body[i]["app_details"]["bundle_id"],
				in_db: true,
				english_vid: response_body[i]["creatives"]["video_url"],
				portrait: response_body[i]["creatives"]["portrait_banner_url"],
				landscape: response_body[i]["creatives"]["banner_url"],
				square_banner: response_body[i]["creatives"]["standard_interstitial_url"],
				flat_banner: response_body[i]["creatives"]["standard_banner_url"],
				english_promo: response_body[i]["creatives"]["description"])
			puts response_body[i]["creatives"]["title"]
		end
	# get offers from HasOffers API
	api_uri = URI "http://api.hasoffers.com/Apiv3/json?NetworkId=hitfox&Target=Offer&Method=findAll&NetworkToken=NETPpPAhSoFvcEVRFbN3XLXkvlqzTs&filters%5Bis_private%5D%5BFALSE%5D=1&filters%5Bstatus%5D=active"
	response = Net::HTTP.start(api_uri.host, api_uri.port) do |http|
	  request = Net::HTTP::Get.new api_uri.request_uri
	  http.request request
	end
	response_body = JSON.parse response.body
	response_array = response_body["response"]["data"].values
	# cross-check with games already in DB, and add bundle ids that aren't already there
	for i in (0..(response_array.length - 1))
		preview = response_array[i]["Offer"]["preview_url"]
		game_name = response_array[i]["Offer"]["name"]
		# check for iOS bundle id
		if preview.match(/\/id([^\/.]*)\?mt/)
			bundle_id = preview.match(/\/id([^\/.]*)\?mt/)
			if Game.find_by(bundle_id: bundle_id[1])
				i = i +1
			else
				Game.create(game_name: game_name, platform: "iOS", bundle_id: bundle_id, in_db: false)
				puts bundle_id[1]
				puts response_array[i]["Offer"]["name"]
			end
		# check for play store bundle id, with "hl=" at the end, or something similar
		elsif preview.match('(?<=id=).*(?=\&)')
			bundle_id = preview.match('(?<=id=).*(?=\&)')
			if Game.find_by(bundle_id: bundle_id[1])
				i = i +1
			else
				Game.create(game_name: game_name, platform: "Android", bundle_id: bundle_id, in_db: false)
				puts bundle_id[0]
				puts response_array[i]["Offer"]["name"]
			end	
		#  finally, look for preview links with just a bundle id at the end, then nothing
		elsif preview.match('(?<=id=).*')
			bundle_id = preview.match('(?<=id=).*')
			if Game.find_by(bundle_id: bundle_id[1])
				i = i +1
			else
				Game.create(game_name: game_name, platform: "Android", bundle_id: bundle_id, in_db: false)
				puts bundle_id[0]
				puts response_array[i]["Offer"]["name"]
			end	
		# if not found, move to next i								
		else
			i = i + 1
		end
	end
	# After filling DB with present and missing games, check cells for actual URLs. Any cell that is "" or 
	# nil, will be replaced by "empty"
		puts "starting task..."
		empty_games = Game.where(square_banner: "")
		empty_games.each do |game|
			game.square_banner = "empty"
			game.save
		end
		nil_games = Game.where(square_banner: nil)
		nil_games.each do |game|
			game.square_banner = "empty"
			game.save
		end
		empty_games = Game.where(flat_banner: "")
		empty_games.each do |game|
			game.flat_banner = "empty"
			game.save
		end
		nil_games = Game.where(flat_banner: nil)
		nil_games.each do |game|
			game.flat_banner = "empty"
			game.save
		end
		empty_games = Game.where(english_promo: "")
		empty_games.each do |game|
			game.english_promo = "empty"
			game.save
		end
		nil_games = Game.where(english_promo: nil)
		nil_games.each do |game|
			game.english_promo = "empty"
			game.save
		end
		empty_games = Game.where(english_vid: "")
		empty_games.each do |game|
			game.english_vid = "empty"
			game.save
		end
		nil_games = Game.where(english_vid: nil)
		nil_games.each do |game|
			game.english_vid = "empty"
			game.save
		end
		nil_games = Game.where(portrait: nil)
		nil_games.each do |game|
			game.portrait = "empty"
			game.save
		end
		nil_games = Game.where(landscape: nil)
		nil_games.each do |game|
			game.landscape = "empty"
			game.save
		end
		puts "task finished"
end

