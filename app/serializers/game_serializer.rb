class GameSerializer
  include JSONAPI::Serializer
  attribute :inst_hash
  attribute :current_pot
  attribute :status
  attribute :end_at
  attribute :ticket_count
  attribute :created_at

  attribute :win_prize do |object|
    object.prize if object.done?
  end
  attribute :sand do |object|
    object.sand if object.done?
  end
  attribute :raw_hash do |object|
    ("%s%s" % [object.prize, object.sand]) if object.done?
  end

  attribute :prize do |object|
    res = object.lotto_prizes
    res.first.prize_value = object.current_pot if res.first.get_all?
    res.map do |e|
      LottoPrizeSerializer.new e
    end
  end
end
