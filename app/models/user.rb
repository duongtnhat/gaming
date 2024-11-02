class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :api
  has_many :accounts

  enum :role, {admin: "admin", ops: "ops"}

  after_save :create_trial_account

  def create_trial_account
    main_curr = Config.get_config "MAIN_CURR", "USDT"
    currency = Currency.find_by_code main_curr
    self.accounts.create balance: 1000, account_type: :casa, currency: currency
  end
end
