class CreateSpecies < ActiveRecord::Migration[5.2]
  def change
    create_table :species do |t|
      t.references :genus, foreign_key: true
      t.string :name, null: false
      t.boolean :venomous, default: false

      t.timestamps
    end
  end
end
