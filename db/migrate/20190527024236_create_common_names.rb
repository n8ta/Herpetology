class CreateCommonNames < ActiveRecord::Migration[5.2]
  def change
    create_table :common_names do |t|
      t.references :taxon, foreign_key: true, null: false
      t.string :name, null: false
      t.timestamps

    end
    add_index :common_names, [:name, :taxon_id], unique: true
  end
end
