class GamesController < ApplicationController
	def index
		#@games = Game.all
		@tasks_grid = initialize_grid(Game)
	end
end
