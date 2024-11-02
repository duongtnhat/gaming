class AddUserTrialFlag < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :trial, :boolean, default: true
  end
end
