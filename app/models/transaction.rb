class Transaction < ApplicationRecord
  belongs_to :currency
  belongs_to :user
  belongs_to :account
  belongs_to :originalCurrency, class_name: Currency.name, optional: true

  enum :trans_type, { place_bet: "PLACE_BET", win: "WIN", deposit: "DEPOSIT", withdraw: "WITHDRAW"}
  enum :status, {
    approved: "APPROVED", denied: "DENIED", error: "ERROR", in_progress: "IN_PROGRESS"
  }

  scope :user_bet, ->(user, game_id) do
    where(user: user, trans_type: :place_bet, source: game_id)
      .includes(:currency)
      .order(created_at: :desc)
  end

  scope :win_count, ->(game_id) do
    where(trans_type: :win, custom_info_05: game_id).group(:source)
  end

  scope :place_bet, ->(user, account, game, amount, bet_value) do
    ActiveRecord::Base.transaction do
      schema = game.lotto_schema
      amount = schema.price if schema.price.present?
      trans = Transaction.new trans_type: :place_bet,
                              amount: amount,
                              currency: account.currency,
                              user: user,
                              account: account,
                              comment: "Place bet for game " + game.id.to_s,
                              source: game.id.to_s,
                              status: :approved,
                              before_balance: account.balance,
                              after_balance: account.balance - amount,
                              custom_info_05: bet_value
      account.balance -= amount
      return "Insufficient balance" if account.balance < 0
      pot = if schema.fixed?
              game.current_pot + amount - schema.fee_value
            elsif schema.percent?
              game.current_pot + amount - schema.fee_value * amount
            else
              game.current_pot + amount
            end
      account.save
      game.update(current_pot: pot)
      trans.save
      trans
    rescue Exception
      raise ActiveRecord::Rollback
    end
  end

  scope :place_bet_batch, ->(user, account, game, amount, bet_value_batch) do
    ActiveRecord::Base.transaction do
      schema = game.lotto_schema
      amount = schema.price if schema.price.present?
      res = []
      bet_value_batch.each do |bet_value|
        trans = Transaction.new trans_type: :place_bet,
                                amount: amount,
                                currency: account.currency,
                                user: user,
                                account: account,
                                comment: "Place bet for game " + game.id.to_s,
                                source: game.id.to_s,
                                status: :approved,
                                before_balance: account.balance,
                                after_balance: account.balance - amount,
                                custom_info_05: bet_value
        account.balance -= amount
        return "Insufficient balance" if account.balance < 0
        pot = if schema.fixed?
                game.current_pot + amount - schema.fee_value
              elsif schema.percent?
                game.current_pot + amount - schema.fee_value * amount
              else
                game.current_pot + amount
              end
        account.save
        game.update(current_pot: pot)
        trans.save
        res.push trans
      end
      res
    rescue Exception
      raise ActiveRecord::Rollback
    end
  end

  def game
    LottoInst.find(self.source)
  end
end
