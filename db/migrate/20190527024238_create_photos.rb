class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.references :taxon, foreign_key: true, null: false
      t.string :image_path, null: false
      t.string :original_url, unique: true
      t.bigint :seen, default: 0, null: false
      t.bigint :correct, default: 0, null: false
      t.timestamps
    end
  end
end
