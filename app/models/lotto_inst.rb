class LottoInst < ApplicationRecord
  self.table_name = "lotto_inst"
  belongs_to :lotto_schema
  has_many :lotto_prizes, -> { order(ordering: :asc) }, through: :lotto_schema
  encrypts :sand
  encrypts :prize

  enum :status, {active: "ACTIVE", done: "DONE"}

  attr_accessor :ticket_count

  scope :active_game, ->(code, limit, page) do
    res = joins(:lotto_schema)
      .includes(:lotto_schema, :lotto_prizes)
      .where(lotto_schema: {enable:true, code: code})
      .order(end_at: :desc)
      .page(page).per(limit)
    res
  end

  scope :get_game_by_id, ->(id) do
    includes(:lotto_schema, :lotto_prizes)
      .where(id: id)
  end

  def process_end_game
    ActiveRecord::Base.transaction do
      schema = self.lotto_schema
      prizes = schema.order_prize
      win_transaction_prize = {}
      transactions = Transaction.where(trans_type: :place_bet, status: :approved, source: self.id.to_s)
      transactions.each do |transaction|
        prizes.each do |prize|
          if prize.win_transaction?(transaction, self)
            add_win(win_transaction_prize, transaction, prize)
            break
          end
        end
      end
      end_game = false
      prizes.each do |prize|
        if win_transaction_prize[prize.code].present?
          end_game = prize.end_round
          prize.pay_win win_transaction_prize[prize.code], self
        end
      end
      if end_game
        schema.update previous_game: nil
      else
        schema.update previous_game: self.current_pot
      end
      self.update status: :done
    rescue Exception
      raise ActiveRecord::Rollback
    end
  end

  private
  def add_win(win, transaction, prize)
    win ||= {}
    if win[prize.code] == nil
      win[prize.code] = []
    end
    win[prize.code].push transaction
  end
end
