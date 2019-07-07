class ReportApprovedRejectedStatus < ActiveRecord::Migration[5.2]
  def up
    add_column :reports, :approved, :boolean, null: true
  end
  def down
    remove_column :reports, :approved
  end
end
