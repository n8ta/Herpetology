class ReportsBelongsToUser < ActiveRecord::Migration[6.1]
  def change
    rename_column('bad_id_reports', 'created_by_id', 'user_id')
    rename_column('bad_region_reports', 'created_by_id', 'user_id')
    rename_column('dead_herp_reports', 'created_by_id', 'user_id')
    rename_column('no_herp_reports', 'created_by_id', 'user_id')
    rename_column('venom_reports', 'created_by_id', 'user_id')
  end
end
