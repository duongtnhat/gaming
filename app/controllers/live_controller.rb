class LiveController < ApplicationController
  def taixiu_live
    render json: response_format(fake_taixiu, 200, "success"), status: 200
  end

  def fake_taixiu
    taixiu_inst = LottoInst
      .joins(:lotto_schema)
      .where(lotto_schema: {game_type: :tai_xiu})
      .order(created_at: :desc)
      .first
    if taixiu_inst.blank? || taixiu_inst.done? || taixiu_inst.start_time < DateTime.current
      $fake_taixiu_cache = {small: 0, big: 0, time: DateTime.now}
      return $fake_taixiu_cache
    end
    curr = $fake_taixiu_cache || {small: 0, big: 0, time: DateTime.now}
    $fake_taixiu_cache = {small: curr[:small] + rand(0..50),
                          big: curr[:big] + rand(0..50), time: DateTime.now}
    $fake_taixiu_cache
  end
end