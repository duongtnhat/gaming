class CreateDocTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :doc_types do |t|
      t.string :name
      t.string :type
      t.string :category
      t.boolean :active

      t.timestamps
    end
  end
end
