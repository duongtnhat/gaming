class LottoController < ApplicationController
  def game_by_code
    code = params[:code]
    limit = params[:limit] || DEFAULT_PAGE_LIMIT
    page = params[:page] || 1
    user_id = params[:user_id]
    @active_game = LottoInst.active_game(code, limit, page).all
    if user_id.present?
      @ticket_count = Transaction.ticket_count(user_id, @active_game.pluck(:id)).count
      @active_game.each do |game|
        game.ticket_count = @ticket_count[game.id.to_s]
      end
    end
    success(@active_game, GameSerializer)
  end
  def game_by_id
    id = params[:id]
    @active_game = LottoInst.get_game_by_id(id).first
    @win_count = Transaction.win_count(id).count
    @active_game.lotto_prizes.each do |prize|
      prize.quantity = @win_count[prize.id.to_s]
    end
    success(@active_game, GameSerializer)
  end
  def schema_by_code
    code = params[:code]
    @schema = LottoSchema.find_by_code code
    success(@schema, LottoSchemaSerializer)
  end
end
