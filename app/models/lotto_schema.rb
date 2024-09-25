class LottoSchema < ApplicationRecord
  belongs_to :currency

  has_many :lotto_inst
  has_many :lotto_prize

  enum :fee_type, { percent: "PERCENT", fixed: "FIXED" }
  enum :game_type, { jackpot: "JACKPOT", tai_xiu: "TAIXIU", keno: "KENO" }
  def new_instance
    instance = self.lotto_inst.build(status: :active)
    current = DateTime.current + self.delay_start || 0
    instance.start_time = current
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
    end_date = DateTime.current + 1.minute
    instance.end_at = Fugit::Cron.new(self.end_round_at).next_time(end_date).to_t
    instance.end_at = DateTimeUtil.start_of :minute, instance.end_at
    instance.save!
  end

  def order_prize
    self.lotto_prize.order(ordering: :asc)
  end
end
