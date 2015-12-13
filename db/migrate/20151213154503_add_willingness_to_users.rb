class AddWillingnessToUsers < ActiveRecord::Migration
  def change
    add_column :users, :will, :boolean, :default => false
    add_column :users, :last_played, :datetime, :default => Time.now
  end
end
