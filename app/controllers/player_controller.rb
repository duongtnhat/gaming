class PlayerController < ApplicationController
  before_action :authenticate_devise_api_token!
  def account
    @accounts = Account.by_player(current_user)
    success(@accounts, AccountSerializer)
  end

  def my_bet
    game_id = params[:game_id] || params[:gameId]
    @my_bet = Transaction.user_bet(current_user, game_id)
    success(@my_bet, BetSerializer)
  end

  def place_bet
    account_id = params[:account_id]
    game_id = params[:game_id]
    amount = params[:amount]
    bet_value = params[:bet_value]

    account = Account.find account_id
    game = LottoInst.find game_id

    errors = validate_bet(current_user, account, game, amount, bet_value)
    if errors.present?
      return error({ data: { error: errors } }, 400, "Cannot place bet")
    end
    bet = Transaction.place_bet current_user, account, game, amount, bet_value
    if bet.is_a? String
      return error({ data: {error: [bet] } }, 400, "Cannot place bet")
    end
    success(bet, BetSerializer)
  end

  def place_bet_batch
    account_id = params[:account_id]
    game_id = params[:game_id]
    amount = params[:amount]
    bet_value = params[:bet_value]

    account = Account.find account_id
    game = LottoInst.find game_id

    errors = validate_bet_batch(current_user, account, game, amount, bet_value)
    if errors.present?
      return error({ data: { error: errors } }, 400, "Cannot place bet")
    end
    bet = Transaction.place_bet_batch current_user, account, game, amount, bet_value
    if bet.is_a? String
      return error({ data: {error: [bet] } }, 400, "Cannot place bet")
    end
    success(bet, BetSerializer)
  end

  private

  def validate_bet(user, account, game, amount, bet_value)
    res = []
    res.push("Account not found") if account.blank?
    res.push("Account invalid") unless account.user_id == user.id and account.casa?
    res.push("Game not found") if game.blank?
    res.push("Game invalid") unless game.active?
    res.push("Amount invalid") if amount.blank? or amount <= 0
    res.push("Bet value invalid") if bet_value.blank? or !bet_value.match?(/^([0-9]+)(,[0-9]+)*$/)
    res
  end

  def validate_bet_batch(user, account, game, amount, bet_value)
    res = []
    res.push("Account not found") if account.blank?
    res.push("Account invalid") unless account.user_id == user.id and account.casa?
    res.push("Game not found") if game.blank?
    res.push("Game invalid") unless game.active?
    res.push("Amount invalid") if amount.blank? or amount <= 0
    res.push("Bet value invalid") unless bet_value.is_a?(Array)
    res.push("Bet value invalid") if bet_value.blank?
    res
  end
end
