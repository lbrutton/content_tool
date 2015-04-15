class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :game_name
      t.string :platform
      t.string :bundle_id
      t.boolean :in_db
      t.string :english_vid
      t.string :portrait
      t.string :landscape
      t.string :square_banner
      t.string :flat_banner
      t.string :english_promo

      t.timestamps null: false
    end
  end
end
