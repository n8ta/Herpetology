class PhotosOriginalUrl < ActiveRecord::Migration[5.2]
  def up
    add_index :photos, :original_url, unique: true
  end
  def down
    remove_index :photos, :original_url
  end
end
