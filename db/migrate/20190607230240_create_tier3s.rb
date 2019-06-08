class CreateTier3s < ActiveRecord::Migration[5.2]
  def change
    create_table :tier3s do |t|
      t.string :name, unique: true
      t.references :tier2, foreign_key: true
      t.timestamps
    end
  end
end
