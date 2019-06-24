class CreateTips < ActiveRecord::Migration[5.2]
  def up
    create_table :tips do |t|
      t.references :user, foreign_key: true
      t.text :content
      t.references :taxon, foreign_key: true
      t.boolean :approved, default: false
      t.timestamps
    end

    add_column :users, :type, :integer
  end
  def down
    drop_table :tips
    remove_column :users, :type
  end
end
