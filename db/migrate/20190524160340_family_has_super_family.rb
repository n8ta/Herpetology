class FamilyHasSuperFamily < ActiveRecord::Migration[5.2]
  def up
    add_foreign_key :families, :superfamilies
  end
  def down
    remove_foreign_key :families, :superfamilies
  end
end
