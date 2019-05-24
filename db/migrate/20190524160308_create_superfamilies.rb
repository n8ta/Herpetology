class CreateSuperfamilies < ActiveRecord::Migration[5.2]
  def change
    create_table :superfamilies do |t|
      t.string :name

      t.timestamps
    end
  end
end
