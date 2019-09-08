class OptOutOfEmail < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :opt_out_of_email, :boolean, default: false
  end
end
