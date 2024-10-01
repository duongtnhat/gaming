class AddUserRoleToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :string, null: true
  end
end
