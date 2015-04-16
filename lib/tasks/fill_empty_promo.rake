desc "fill all empty promo slots with 'empty'"
task :fill_empty_promo => :environment do 
	puts "starting task..."
	empty_games = Game.where(english_promo: "")
	empty_games.each do |game|
		game.english_promo = "empty"
		game.save
	end
	puts "task finished"
end