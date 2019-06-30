class Deceased < ActiveRecord::Migration[5.2]
  def up
    add_column :photos, :dead, :boolean, default: false
  end
  def down
    remove_column :photos, :dead
  end
end
