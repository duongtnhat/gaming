class AddStartTimeToGameInstance < ActiveRecord::Migration[7.0]
  def change
    add_column :lotto_inst, :start_time, :datetime, null: true
    add_column :lotto_schemas, :delay_start, :integer
  end
end
