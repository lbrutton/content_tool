desc "fill all empty video slots with 'empty'"
task :fill_empty_vids => :environment do 
	puts "starting task..."
	empty_games = Game.where(english_vid: "")
	empty_games.each do |game|
		game.english_vid = "empty"
		game.save
	end
	puts "task finished"
end