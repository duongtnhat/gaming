class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :trans_type
      t.decimal :amount
      t.references :currency, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.string :comment
      t.string :error
      t.datetime :ext_tran_date
      t.string :ext_tran_id
      t.string :status
      t.decimal :before_balance
      t.decimal :after_balance
      t.string :game_session
      t.string :source
      t.integer :original_trans_id
      t.decimal :original_amount
      t.references :original_currency, null: true, foreign_key: { to_table: :currencies }
      t.string :custom_info_01
      t.string :custom_info_02
      t.string :custom_info_03
      t.string :custom_info_04
      t.string :custom_info_05

      t.timestamps
    end
  end
end
