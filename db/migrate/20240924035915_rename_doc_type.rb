class RenameDocType < ActiveRecord::Migration[7.0]
  def change
    rename_column :doc_types, :type, :code
  end
end
