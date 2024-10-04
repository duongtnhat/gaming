class Doc < ApplicationRecord
  belongs_to :doc_type
  belongs_to :user
  belongs_to :currency

  enum :status, {pending: "PENDING", approved: "APPROVED", success: "SUCCESS", deny: "DENY"}

  validates :amount, numericality: { other_than: 0 }
  validates :ext_id, presence: true, uniqueness: true

  after_update :approve_doc
  before_update :set_approved_at

  scope :list_payment, ->(user, page, limit) do
    includes(:doc_type, :currency)
      .where(user: user).order(created_at: :desc)
      .page(page).per(limit)
  end

  def set_approved_at
    if self.status_changed?
      self.approved_at = DateTime.now
    end
  end
  def approve_doc
    return true unless self.deny?
    main_curr = Config.get_config "MAIN_CURR", "USDT"
    hold = Account.get_hold_account(self.user).first
    casa = Account.by_player_and_currency(self.user, main_curr).first
    casa.balance += amount
    hold.balance -= amount
    casa.save!
    hold.save!
    true
  rescue Exception
    raise ActiveRecord::RecordInvalid.new(self)
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

  def self.create_withdraw(user, amount, address)
    main_curr = Config.get_config "MAIN_CURR", "USDT"
    main_currency = Currency.find_by_code main_curr
    res = Doc.new
    res.doc_type = DocType.find_by_code('PAYOUT')
    res.user = user
    res.amount = amount
    res.source = address
    res.ext_id = SecureRandom.hex
    res.action = "PAYOUT"
    res.status = :pending
    res.auth_code = SecureRandom.hex
    res.comment = "Create payout for account " + user.email
    res.currency = main_currency
    ActiveRecord::Base.transaction do
      hold = Account.get_hold_account(user).first
      casa = Account.by_player_and_currency(user, main_curr).first
      if hold.blank?
        hold = Account.create(balance: 0, currency: main_currency, user: user, account_type: :hold)
      end
      casa.balance -= amount
      unless casa.save
        res.errors.add(:base, "Insufficient balance")
        return res
      end
      hold.balance += amount
      hold.save
      res.save
    rescue Exception
      raise ActiveRecord::Rollback
    end
    res
  end
end
