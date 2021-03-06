class CreateReports < ActiveRecord::Migration[5.2]
  def up
    create_table :reports do |t|
      t.references :taxon, foreign_key: true, null: true
      t.references :photo, foreign_key: true, null: false
      t.boolean :handled, null: false, default: false
      t.bigint :created_by, foreign_key: true, null: true
      t.bigint :handled_by, foreign_key: true, null: true
      t.string :venomous
      t.boolean :no_herp, default: false
      t.timestamps
    end
    add_foreign_key :reports, :users, column: :created_by
    add_foreign_key :reports, :users, column: :handled_by
  end

  def down
    drop_table :reports
  end
end
