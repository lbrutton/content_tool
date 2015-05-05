class AddCategoriesToGames < ActiveRecord::Migration
  def change
  	add_column :games, :category, :string
  end
end
