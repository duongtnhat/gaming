class Doc < ApplicationRecord
  belongs_to :doc_type
  belongs_to :user
  belongs_to :currency

  enum :status, {pending: "PENDING", approved: "APPROVED", success: "SUCCESS", deny: "DENY"}

  validates :amount, numericality: { other_than: 0 }
  validates :ext_id, presence: true

  scope :list_payment, ->(user, page, limit) do
    includes(:doc_type, :currency)
      .where(user: user).order(created_at: :desc)
      .page(page).per(limit)
  end

  def self.create_deposit(user, amount, currency, ext_id)
    res = Doc.new
    res.doc_type = DocType.find_by_code('DEPOSIT')
    res.user = user
    res.amount = amount
    res.ext_id = ext_id
    res.action = "DEPOSIT"
    res.status = :pending
    res.auth_code = SecureRandom.hex
    res.comment = "Create deposit for account " + user.email
    res.currency = Currency.where(code: currency, enable: true).first
    res
  end
end
