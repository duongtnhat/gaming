class Account < ApplicationRecord
  belongs_to :currency
  belongs_to :user

  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  enum :account_type, { casa: "CASA", gl: "GL" }

  scope :by_player, -> (player) do
    includes(:currency).where(user: player, account_type: :casa)
  end
  scope :by_player_and_currency, -> (player, currency) do
    includes(:currency).where(user: player, account_type: :casa)
                       .where(currency: {code: currency})
  end
end
