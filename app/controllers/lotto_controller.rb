class LottoController < ApplicationController
  def game_by_code
    code = params[:code]
    limit = params[:limit] || DEFAULT_PAGE_LIMIT
    page = params[:page] || 1
    @active_game = LottoInst.active_game code, limit, page
    success(@active_game, GameSerializer)
  end
end
