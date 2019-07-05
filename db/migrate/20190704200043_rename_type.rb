class RenameType < ActiveRecord::Migration[5.2]
  def up
    rename_column :users, :type, :user_class
  end
  def down
    rename_column :users, :user_class, :type
  end
end
