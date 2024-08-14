class CreateLottoSchemas < ActiveRecord::Migration[7.0]
  def change
    create_table :lotto_schemas do |t|
      t.string :name
      t.string :code
      t.decimal :price
      t.integer :range_from
      t.integer :range_to
      t.integer :win_number
      t.boolean :duplicate
      t.string :new_round_at
      t.string :end_round_at
      t.string :fee_type
      t.decimal :fee_value
      t.decimal :initial_amount
      t.boolean :enable
      t.references :currency, null: false, foreign_key: true

      t.timestamps
    end
  end
end
