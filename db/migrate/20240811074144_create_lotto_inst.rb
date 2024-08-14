class CreateLottoInst < ActiveRecord::Migration[7.0]
  def change
    create_table :lotto_inst do |t|
      t.references :lotto_schema, null: false, foreign_key: true
      t.string :hash
      t.string :sand
      t.string :prize
      t.string :current_pot
      t.string :status
      t.datetime :end_at

      t.timestamps
    end
  end
end
