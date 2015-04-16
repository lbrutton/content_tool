desc "fill all empty banner slots with 'empty'"
task :fill_empty_banners => :environment do 
	puts "starting task..."
	empty_games = Game.where(square_banner: "")
	empty_games.each do |game|
		game.square_banner = "empty"
		game.save
	end
	puts "task finished"
end