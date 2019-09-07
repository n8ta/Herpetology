class BadRegionReport < ActiveRecord::Migration[5.2]
  def change
    create_table :bad_region_reports  do |t|
      t.boolean :handled, null: false, default: false
      t.boolean :approved, default: false
      t.bigint :created_by_id, foreign_key: true, null: true
      t.bigint :handled_by_id, foreign_key: true, null: true
      t.timestamps
      t.references :region, foreign_key: true, null: false
      t.references :taxon, foreign_key: true, null: false
    end

  end
end
