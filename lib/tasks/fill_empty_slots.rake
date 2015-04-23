desc "fill all empty creative slots with 'empty'"
task :fill_empty_slots => :environment do 
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