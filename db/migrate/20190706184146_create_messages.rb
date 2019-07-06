class CreateMessages < ActiveRecord::Migration[5.2]
  def up
    create_table :messages do |t|
      t.text :content
      t.references :report, foreign_key: true
      t.bigint :src, foreign_key: true
      t.bigint :dst, foreign_key: true
      t.timestamps
    end
    add_foreign_key :messages, :users, column: :src
    add_foreign_key :messages, :users, column: :dst
  end
  def down
    drop_table :messages
  end
end
