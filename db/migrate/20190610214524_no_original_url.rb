class NoOriginalUrl < ActiveRecord::Migration[5.2]
  def up
    remove_column :photos, :original_url
  end
  def down
    add_column :photos, :original_url, :string
  end
end
