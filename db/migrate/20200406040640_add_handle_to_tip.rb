class AddHandleToTip < ActiveRecord::Migration[6.0]
  def up
    add_column :tips, :handled, :boolean, default: false
  end
  def down
    remove_column :tips, :handled
  end

end
