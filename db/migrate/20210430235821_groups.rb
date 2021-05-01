class Groups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :name
    end

    create_join_table :groups, :taxons
  end
end
