class CreateLottoPrizes < ActiveRecord::Migration[7.0]
  def change
    create_table :lotto_prizes do |t|
      t.string :name
      t.string :code
      t.integer :fill
      t.integer :ordering
      t.decimal :prize_value
      t.string :prize_type
      t.boolean :enable
      t.boolean :end_round
      t.boolean :distribute

      t.timestamps
    end
    add_index :lotto_prizes, :code, unique: true
  end
end
