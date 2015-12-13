class Team < ActiveRecord::Base
  has_many :users
  has_one :game1, :class_name => "Game", :foreign_key => "team1_id"
  has_one :game2, :class_name => "Game", :foreign_key => "team2_id"

end
