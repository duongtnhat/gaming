class AddPrizeLengthInLottoPrize < ActiveRecord::Migration[7.0]
  def change
    add_column :lotto_prizes, :prize_length, :integer, null: true
  end
end
