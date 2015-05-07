class GamesController < ApplicationController
  before_action :authenticate_user!
	def index
		#@games = Game.all
		@tasks_grid = initialize_grid(Game)
		@total_games = Game.where(in_db: true).count
		@total_games_without_promo = Game.where(english_promo:"empty").where(in_db: true).count.to_f
		@total_games_without_square_banners = Game.where(square_banner:"empty").where(in_db: true).count.to_f
		@total_games_without_flat_banners = Game.where(flat_banner:"empty").where(in_db: true).count.to_f
		@total_games_without_video = Game.where(english_vid:"empty").where(in_db: true).count.to_f
	end
end
