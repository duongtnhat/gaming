class LottoPrizesSchema < ActiveRecord::Migration[7.0]
  def change
    add_reference :lotto_prizes, :lotto_schema, null: false, foreign_key: true
  end
end
