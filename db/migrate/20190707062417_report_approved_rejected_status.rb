class ReportApprovedRejectedStatus < ActiveRecord::Migration[5.2]
  def up
    add_column :reports, :approved, :boolean, null: true
    rename_column :reports, :created_by, :created_by_id
    rename_column :reports, :handled_by, :handled_by_id

  end
  def down
    remove_column :reports, :approved
    rename_column :reports, :created_by_id, :created_by
    rename_column :reports, :handled_by_id, :handled_by

  end
end
