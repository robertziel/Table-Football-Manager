class AddWillingnessToUsers < ActiveRecord::Migration
  def change
    add_column :users, :will, :boolean
    add_column :users, :last_played, :datetime
  end
end
