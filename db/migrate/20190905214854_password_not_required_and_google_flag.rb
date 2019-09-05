class PasswordNotRequiredAndGoogleFlag < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :encrypted_password, true
    add_column :users, :google_user, :boolean, default: false
  end
end
