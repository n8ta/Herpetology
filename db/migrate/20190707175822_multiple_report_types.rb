class MultipleReportTypes < ActiveRecord::Migration[5.2]
  def up
    remove_foreign_key :messages, :reports
    drop_table :reports


    create_table :no_herp_reports do |t|
      t.boolean :handled, null: false, default: false
      t.boolean :approved, default: false
      t.bigint :created_by_id, foreign_key: true, null: true
      t.bigint :handled_by_id, foreign_key: true, null: true
      t.timestamps
      t.references :photo, foreign_key: true, null: false
    end

    create_table :bad_id_reports do |t|
      t.boolean :handled, null: false, default: false
      t.boolean :approved, default: false
      t.bigint :created_by_id, foreign_key: true, null: true
      t.bigint :handled_by_id, foreign_key: true, null: true
      t.timestamps

      t.references :taxon, foreign_key: true, null: false
      t.references :photo, foreign_key: true, null: false
    end

    create_table :venom_reports do |t|
      t.boolean :handled, null: false, default: false
      t.boolean :approved, default: false
      t.bigint :created_by_id, foreign_key: true, null: true
      t.bigint :handled_by_id, foreign_key: true, null: true
      t.timestamps

      t.references :taxon, foreign_key: true, null: false
      t.integer :venomous, null: false
    end

    create_table :dead_herp_reports do |t|
      t.boolean :handled, null: false, default: false
      t.boolean :approved, default: false
      t.bigint :created_by_id, foreign_key: true, null: true
      t.bigint :handled_by_id, foreign_key: true, null: true
      t.timestamps

      t.references :photo, foreign_key: true, null: false
    end
  end

  def down
    create_table :reports
    add_foreign_key :messages, :reports
    drop_table :dead_herp_reports
    drop_table :bad_id_reports
    drop_table :venom_reports
    drop_table :no_herp_reports
  end
end
