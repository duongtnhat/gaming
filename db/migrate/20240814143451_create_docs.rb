class CreateDocs < ActiveRecord::Migration[7.0]
  def change
    create_table :docs do |t|
      t.references :doc_type, null: false, foreign_key: true
      t.string :action
      t.string :status
      t.references :user, null: false, foreign_key: true
      t.string :auth_code
      t.string :ext_id
      t.string :comment
      t.string :source
      t.integer :source_id
      t.decimal :amount, precision: 15, scale: 8
      t.references :currency, null: false, foreign_key: true
      t.datetime :approved_at

      t.timestamps
    end
  end
end
