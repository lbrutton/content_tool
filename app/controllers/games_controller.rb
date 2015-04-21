class GamesController < ApplicationController
	def index
		#@games = Game.all
		@tasks_grid = initialize_grid(Game)
		@total_games = Game.count
		@total_games_without_promo = Game.where(english_promo:"empty").count
		@total_games_without_square_banners = Game.where(square_banner:"empty").count
		@total_games_without_flat_banners = Game.where(flat_banner:"empty").count
		@total_games_without_video = Game.where(english_vid:"empty").count
	end
end
