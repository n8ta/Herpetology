class CreateUserTaxonData < ActiveRecord::Migration[5.2]
  def change
    create_table :user_taxon_data do |t|
      t.references :taxon, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.bigint :seen, default: 0, null: false
      t.bigint :correct, default: 0, null: false
      t.timestamps
    end
  end
end
