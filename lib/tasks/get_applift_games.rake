require 'net/http'
desc "get games from HO API and add to DB"
task :get_applift_games => :environment do 
	puts "starting task..."
	api_uri = URI #{spreadsheet_API_here}
	response = Net::HTTP.start(api_uri.host, api_uri.port) do |http|
	  request = Net::HTTP::Get.new api_uri.request_uri
	  http.request request
	end
	response_body = JSON.parse response.body
	#Rake::Task['db:reset'].invoke
	body_length = response_body.length
		#game_indexes = (0..(body_length-1)).to_a.sort{rand() - 0.5}[0..5]
		# for i in (0..body_length)
		# 	if 
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
		puts response_body[0]
	puts "task finished"
end