class DatumSciAndCommmon < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_taxon_data, :seen
    remove_column :user_taxon_data, :correct
    add_column :user_taxon_data, :sci_seen, :bigint, default: 0, null: false
    add_column :user_taxon_data, :sci_correct, :bigint, default: 0, null: false
    add_column :user_taxon_data, :common_seen, :bigint, default: 0, null: false
    add_column :user_taxon_data, :common_correct, :bigint, default: 0, null: false
  end
end
