class PhotoCanBeHidden < ActiveRecord::Migration[5.2]
  def up
    add_column :photos, :hidden, :boolean, default: false, null: false
  end
  def down
    remove_column :photos, :hidden
  end
end
