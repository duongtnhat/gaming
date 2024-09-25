class Doc < ApplicationRecord
  belongs_to :doc_type
  belongs_to :user
  belongs_to :currency

  enum :status, {pending: "PENDING", approved: "APPROVED", success: "SUCCESS", deny: "DENY"}

  scope :list_payment, ->(user, page, limit) do
    includes(:doc_type, :currency)
      .where(user: user).order(created_at: :desc)
      .page(page).per(limit)
  end
end
