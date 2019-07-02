class UserDeadPreference < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :show_dead_photos, :bool, default: false
  end
end
