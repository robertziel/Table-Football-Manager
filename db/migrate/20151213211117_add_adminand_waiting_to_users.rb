class AddAdminandWaitingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, :default => false
    add_column :users, :wait, :boolean, :default => true
  end
end
