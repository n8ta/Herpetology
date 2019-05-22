class CreateGenera < ActiveRecord::Migration[5.2]
  def change
    create_table :genera do |t|
      t.string :name, null: false
      t.references :family, foreign_key: true, null: false

      t.timestamps
    end
  end
end
