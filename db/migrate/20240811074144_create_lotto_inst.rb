class CreateLottoInst < ActiveRecord::Migration[7.0]
  def change
    create_table :lotto_inst do |t|
      t.references :lotto_schema, null: false, foreign_key: true
      t.string :inst_hash
      t.string :sand
      t.string :prize
      t.decimal :current_pot, precision: 15, scale: 8
      t.string :status
      t.datetime :end_at

      t.timestamps
    end
  end
end
