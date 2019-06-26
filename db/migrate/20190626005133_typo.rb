class Typo < ActiveRecord::Migration[5.2]
  def up
    rename_column :taxons, :photograped, :photographed
  end
end
