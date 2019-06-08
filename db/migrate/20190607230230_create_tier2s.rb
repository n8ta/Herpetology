class CreateTier2s < ActiveRecord::Migration[5.2]
  def change
    create_table :tier2s do |t|
      t.string :name, unique: true
      t.references :tier1, foreign_key: true

      t.timestamps
    end
  end
end
