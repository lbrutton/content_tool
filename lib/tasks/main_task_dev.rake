#same as main_task_v2, but without the proxy because it isn't needed, only to be used in dev - will be 
#changed use the environment as a parameter passed to the task when someone has time

namespace :apis_task_dev do
  desc "fill database with bulk API apps, cross-check with offers from HasOffers, then fill empty creative slots"
  task :main_task_dev => :environment do 
    puts "starting task..."
    puts 'fuck it'
    # get games from bulk API
    api_uri = URI #{API_call_here}
    response = Net::HTTP.start(api_uri.host, api_uri.port) do |http|
      request = Net::HTTP::Get.new api_uri.request_uri
      http.request request
    end
    response_body = JSON.parse response.body
    #Rake::Task['db:reset'].invoke
    body_length = response_body.length
    # add those games to DB
    y = 0
    for i in (0..body_length - 1)
      bundle_id = response_body[i]["app_details"]["bundle_id"]
      if Game.find_by(bundle_id: bundle_id) 
        i += 1
        y += 1
      else
        Game.create(game_name: response_body[i]["creatives"]["title"],
          platform: response_body[i]["app_details"]["platform"],        
          bundle_id: response_body[i]["app_details"]["bundle_id"],
          in_db: true,
          english_vid: response_body[i]["creatives"]["video_url"],
          portrait: response_body[i]["creatives"]["portrait_banner_url"],
          landscape: response_body[i]["creatives"]["banner_url"],
          square_banner: response_body[i]["creatives"]["standard_interstitial_url"],
          flat_banner: response_body[i]["creatives"]["standard_banner_url"],
          english_promo: response_body[i]["creatives"]["description"],
          category: response_body[i]["app_details"]["category"])
        puts response_body[i]["creatives"]["title"]
      end
    end
    puts "#{y} new apps were added from the bulk API"
    # get offers from HasOffers API
    api_uri = URI #{HO_API_here}
    # proxy = URI "http://quotaguard2619:dd0d6e315d59@us-east-1-static-brooks.quotaguard.com:9293"
    response = Net::HTTP.start(api_uri.host, api_uri.port) do |http|
      request = Net::HTTP::Get.new api_uri.request_uri
      http.request request
    end
    response_body = JSON.parse response.body
    @response_array = response_body["response"]["data"].values
    # cross-check with games already in DB, and add bundle ids that aren't already there
    x = 0
    for i in (0..(@response_array.length - 1))
      preview = @response_array[i]["Offer"]["preview_url"]
      @game_name = @response_array[i]["Offer"]["name"]
      # exclude every offer with redirect in the name
      if !@game_name.match('(?i)redirect') and !@game_name["Pro Sniper"]
        # check for iOS bundle id
        if preview.match('(?<=/id).*(?=\/)')
          @bundle_id = preview.match('(?<=/id).*(?=\/)')
          if create_game("iOS", i)
            x += 1
            puts "#{@game_name} was added to the db"
            create_game("iOS", i)
          else
            i += 1
          end
        elsif preview.match('(?<=/id).*(?=\?)')
          @bundle_id = preview.match('(?<=/id).*(?=\?)')
          if create_game("iOS", i)
            x += 1
            puts "#{@game_name} was added to the db"
            create_game("iOS", i)
          else
            i += 1
          end
        elsif preview.match('(?<=/id).*')
          @bundle_id = preview.match('(?<=id).*')
          if create_game("iOS", i)
            x += 1
            puts "#{@game_name} was added to the db"
            create_game("iOS", i)
          else
            i += 1
          end 
        # check for play store bundle id, with "hl=" at the end, or something similar
        elsif preview.match('(?<=id=).*(?=\&)')
          @bundle_id = preview.match('(?<=id=).*(?=\&)')
          if create_game("Android", i)
            x += 1
            puts "#{@game_name} was added to the db"
            create_game("Android", i)
          else
            i += 1
          end 
        #  finally, look for preview links with just a bundle id at the end, then nothing
        elsif preview.match('(?<=id=).*')
          @bundle_id = preview.match('(?<=id=).*')
          if create_game("Android", i)
            x += 1
            puts "#{@game_name} was added to the db"
            create_game("Android", i)
          else
            i += 1
          end 
        # if not found, move to next element              
        else
          i += 1
        end
      end
    end
    # get offers from Appiris API
    api_uri = URI #{HO_Appiris_call_here}
    response = Net::HTTP.start(api_uri.host, api_uri.port) do |http|
      request = Net::HTTP::Get.new api_uri.request_uri
      http.request request
    end
    response_body = JSON.parse response.body
    @response_array = response_body["response"]["data"].values
    # cross-check with games already in DB, and add bundle ids that aren't already there
    for i in (0..(@response_array.length - 1))
      preview = @response_array[i]["Offer"]["preview_url"]
      @game_name = @response_array[i]["Offer"]["name"]
      # exclude every offer with redirect in the name
      if !@game_name.match('(?i)redirect') and !@game_name["Pro Sniper"]
        # check for iOS bundle id
        if preview.match('(?<=/id).*(?=\/)')
          @bundle_id = preview.match('(?<=/id).*(?=\/)')
          if create_game("iOS", i)
            x += 1
            puts "#{@game_name} was added to the db"
            create_game("iOS", i)
          else
            i +=1
          end
        elsif preview.match('(?<=/id).*(?=\?)')
          @bundle_id = preview.match('(?<=/id).*(?=\?)')
          if create_game("iOS", i)
            x += 1
            puts "#{@game_name} was added to the db"
            create_game("iOS", i)
          else
            i += 1
          end
        elsif preview.match('(?<=/id).*')
          @bundle_id = preview.match('(?<=id).*')
          if create_game("iOS", i)
            x += 1
            puts "#{@game_name} was added to the db"
            create_game("iOS", i)
          else
           i += 1
          end 
        # check for play store bundle id, with "hl=" at the end, or something similar
        elsif preview.match('(?<=id=).*(?=\&)')
          @bundle_id = preview.match('(?<=id=).*(?=\&)')
          if create_game("Android", i)
            x += 1
            puts "#{@game_name} was added to the db"
            create_game("Android", i)
          else
            i += 1
          end 
        #  finally, look for preview links with just a bundle id at the end, then nothing
        elsif preview.match('(?<=id=).*')
          @bundle_id = preview.match('(?<=id=).*')
          if create_game("Android", i)
            x += 1
            puts "#{@game_name} was added to the db"
            create_game("Android", i)
          else
            i += 1
          end 
        # if not found, move to next element              
        else
          i += 1
        end
      end
    end
    # After filling DB with present and missing games, check cells for actual URLs. 
    # Any cell that is "" or nil, will be replaced by "empty"
    puts "#{x} apps were added to the DB motherfucker"
    puts "starting task..."
    find_and_save("square_banner", "")
    find_and_save("square_banner", nil)
    find_and_save("flat_banner", "")
    find_and_save("flat_banner", nil)
    find_and_save("english_promo", "")
    find_and_save("english_promo", nil)
    find_and_save("english_vid", "")
    find_and_save("english_vid", nil)
    puts "task finished"
  end

  desc "fill database with bulk API apps, then fill empty creative slots"
  task :main_task_no_HO_dev => :environment do 
    puts "starting task..."
    # get games from bulk API
    api_uri = URI #{bulk_API_here}
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
    puts "starting task..."
    find_and_save("square_banner", "")
    find_and_save("square_banner", nil)
    find_and_save("flat_banner", "")
    find_and_save("flat_banner", nil)
    find_and_save("english_promo", "")
    find_and_save("english_promo", nil)
    find_and_save("english_vid", "")
    find_and_save("english_vid", nil)
    puts "task finished"
  end
  
  def find_game
    Game.find_by(bundle_id: @bundle_id[1]) 
  end
  def create_game(platform, i)
    Game.create(game_name: @game_name, platform: platform, bundle_id: @bundle_id, in_db: false)
  end
  def find_and_save(att_type, comparisson_obj)
    if comparisson_obj.nil?
      nil_games = Game.where("#{att_type}" => nil)
    elsif comparisson_obj.empty?
      nil_games = Game.where("#{att_type} = ''")
    end
    nil_games.each do |game|
      game.send("#{att_type}=", "empty")
      game.save
    end
  end
end
