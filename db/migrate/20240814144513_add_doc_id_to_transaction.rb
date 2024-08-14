class AddDocIdToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_reference :transactions, :doc, index: true, null: true
  end
end
