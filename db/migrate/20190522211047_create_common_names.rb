class CreateCommonNames < ActiveRecord::Migration[5.2]
  def change
    create_table :common_names do |t|
      t.references :species, foreign_key: true, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
