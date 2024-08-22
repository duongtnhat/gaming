class LottoSchema < ApplicationRecord
  belongs_to :currency

  has_many :lotto_inst
  has_many :lotto_prize

  enum :fee_type, { percent: "PERCENT", fixed: "FIXED" }
  enum :game_type, { jackpot: "JACKPOT", tai_xiu: "TAIXIU" }
  def new_instance
    instance = self.lotto_inst.build(status: :active)
    instance.prize = RandomUtil.random(
      self.range_from..self.range_to,
      self.win_number,
      self.duplicate
    ).join(",")
    instance.sand = SecureRandom.hex
    if self.jackpot?
      instance.current_pot = self.previous_game || self.initial_amount
    elsif self.tai_xiu?
      instance.current_pot = self.initial_amount
    else
      instance.current_pot = 0
    end
    instance.inst_hash = Digest::MD5.hexdigest("%s%s" % [instance.prize, instance.sand])
    instance.end_at = Fugit::Cron.new(self.end_round_at).next_time(DateTime.current).to_t
    instance.save!
  end

  def order_prize
    self.lotto_prize.order(ordering: :asc)
  end
end
