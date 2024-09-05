class LottoPrize < ApplicationRecord
  belongs_to :lotto_schema

  enum :prize_type, { get_all: "ALL", fixed_value: "FIXED", rate: "RATE" }

  def win_transaction? transaction, game
    schema = self.lotto_schema
    if schema.jackpot?
      win = game.prize.split(",")
      curr = transaction.custom_info_05.split(",").uniq
      return false if (win.size != curr.size)
      not_match = (win-curr).size
      return self.fill <= schema.win_number - not_match
    end
    if schema.tai_xiu?
      win = game.prize
      sum = win.split(",").map(&:to_i).sum
      if transaction.custom_info_05 == "0" and sum <= 10
        return true
      elsif transaction.custom_info_05 == "1" and sum > 10
        return true
      else
        return false
      end
    end
    if schema.keno?
      curr = transaction.custom_info_05.split(",").uniq
      return false if self.prize_length != curr.size
      win = game.prize.split(",")
      match_number = curr.select {|e| win.include?(e) }
      return match_number == self.fill
    end
    false
  rescue Error
    false
  end

  def pay_win transactions, game
    transactions.each do |transaction|
      amount = if self.get_all?
                 game.current_pot / transactions.size
               elsif self.fixed_value?
                 self.prize_value
               elsif self.rate?
                 transaction.amount * prize_value
               else
                 transaction.amount
               end
      account = transaction.account
      user = transaction.user

      update_win user, amount, account, game, transaction
    end
  end

  private

  def update_win user, amount, account, game, transaction
    ActiveRecord::Base.transaction do
      trans = Transaction.new trans_type: :win,
                              amount: amount,
                              currency: account.currency,
                              user: user,
                              account: account,
                              comment: "Win game for game " + game.id.to_s,
                              source: self.id.to_s,
                              status: :approved,
                              original_trans_id: transaction.id,
                              custom_info_05: game.id.to_s,
                              before_balance: account.balance,
                              after_balance: account.balance + amount
      account.balance += amount
      trans.save!
      transaction.update! original_trans_id: trans.id, custom_info_04: self.id.to_s,
                          custom_info_03: amount
      account.save!
    rescue Error
      raise ActiveRecord::Rollback
    end
  end
end
