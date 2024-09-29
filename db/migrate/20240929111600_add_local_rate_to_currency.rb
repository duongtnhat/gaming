class AddLocalRateToCurrency < ActiveRecord::Migration[7.0]
  def change
    add_column :currencies, :local_rate, :decimal, precision: 20, scale: 8, default: 1
  end
end
