class Transaction < ApplicationRecord
  belongs_to :currency
  belongs_to :user
  belongs_to :account
  belongs_to :originalTransId
  belongs_to :originalCurrency
end
