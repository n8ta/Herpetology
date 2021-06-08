class ReportsBelongsToUserPart2 < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key('bad_id_reports','users', column: 'user_id')
    add_foreign_key('bad_region_reports','users', column: 'user_id')
    add_foreign_key('dead_herp_reports','users', column: 'user_id')
    add_foreign_key('no_herp_reports','users', column: 'user_id')
    add_foreign_key('venom_reports','users', column: 'user_id')
  end
end
