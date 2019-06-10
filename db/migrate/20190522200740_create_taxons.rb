class CreateTaxons < ActiveRecord::Migration[5.2]
  def change
    create_table :taxons do |t|
      t.string :name
      t.references :taxon, foreign_key: true
      t.integer :rank
    end
  end
end
