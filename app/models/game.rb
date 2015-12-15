class Game < ActiveRecord::Base
  belongs_to :team1, :class_name => 'Team', :foreign_key => 'team1_id'
  belongs_to :team2, :class_name => 'Team', :foreign_key => 'team2_id'

  validates_presence_of :team1_id
  validates_presence_of :team2_id

  has_many :users

end
