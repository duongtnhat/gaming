class CreateCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :symbol
      t.string :code
      t.boolean :isCrypto
      t.boolean :enable

      t.timestamps
    end
    add_index :currencies, :code, unique: true
  end
end
