desc "fill all empty 320x50 slots with 'empty'"
task :fill_empty_flat_banners => :environment do 
	puts "starting task..."
	empty_games = Game.where(flat_banner: "")
	empty_games.each do |game|
		game.flat_banner = "empty"
		game.save
	end
	puts "task finished"
end