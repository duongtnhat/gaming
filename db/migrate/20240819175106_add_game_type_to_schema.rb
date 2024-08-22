class AddGameTypeToSchema < ActiveRecord::Migration[7.0]
  def change
    add_column :lotto_schemas, :game_type, :string
    add_column :lotto_schemas, :previous_game, :decimal, precision: 15, scale: 8
  end
end
