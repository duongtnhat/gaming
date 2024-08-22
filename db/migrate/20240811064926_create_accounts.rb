class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.decimal :balance, precision: 15, scale: 8
      t.references :currency, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :account_type

      t.timestamps
    end
  end
end
