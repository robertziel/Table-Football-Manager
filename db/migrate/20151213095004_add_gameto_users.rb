class AddGametoUsers < ActiveRecord::Migration
  def change
      add_column :users, :game_id, :integer
      add_column :users, :team_id, :integer
  end
end
