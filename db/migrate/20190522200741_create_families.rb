class CreateFamilies < ActiveRecord::Migration[5.2]
  def change
    create_table :families do |t|
      t.string :name
      t.references :superfamily, foreign_key: true

      t.timestamps
    end
  end
end
