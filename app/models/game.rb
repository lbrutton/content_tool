class Game < ActiveRecord::Base
	validates :bundle_id, uniqueness: true
end
