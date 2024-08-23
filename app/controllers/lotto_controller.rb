class LottoController < ApplicationController
  def game_by_code
    code = params[:code]
    limit = params[:limit] || DEFAULT_PAGE_LIMIT
    page = params[:page] || 1
    @active_game = LottoInst.active_game code, limit, page
    success(@active_game, GameSerializer)
  end
  def game_by_id
    id = params[:id]
    @active_game = LottoInst.get_game_by_id id
    success(@active_game, GameSerializer)
  end
  def schema_by_code
    code = params[:code]
    @schema = LottoSchema.find_by_code code
    success(@schema, LottoSchemaSerializer)
  end
end