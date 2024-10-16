class AddInfoForDoc < ActiveRecord::Migration[7.0]
  def change
    add_column :docs, :chain, :string
    add_column :docs, :add_info_01, :string
    add_column :docs, :add_info_02, :string
    add_column :docs, :add_info_03, :string
    add_column :docs, :add_info_04, :string
    add_column :docs, :add_info_05, :string
  end
end
