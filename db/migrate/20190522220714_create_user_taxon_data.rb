class CreateUserSpeciesData < ActiveRecord::Migration[5.2]
  def change
    create_table :user_species_data do |t|
      t.references :species, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.bigint :seen, default: 0, null: false
      t.bigint :correct, default: 0, null: false
      t.timestamps
    end
  end
end
