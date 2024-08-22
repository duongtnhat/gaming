class CreateLottoSchemas < ActiveRecord::Migration[7.0]
  def change
    create_table :lotto_schemas do |t|
      t.string :name
      t.string :code
      t.decimal :price, precision: 15, scale: 8
      t.integer :range_from
      t.integer :range_to
      t.integer :win_number
      t.boolean :duplicate
      t.string :new_round_at
      t.string :end_round_at
      t.string :fee_type
      t.decimal :fee_value, precision: 15, scale: 8
      t.decimal :initial_amount, precision: 15, scale: 8
      t.boolean :enable
      t.references :currency, null: false, foreign_key: true

      t.timestamps
    end
  end
end
