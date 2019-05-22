class CreateRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :regions do |t|
      t.string :name, null: false
      t.string :image_path, null: false

      t.timestamps
    end
  end
end
