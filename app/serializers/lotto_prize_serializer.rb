class LottoPrizeSerializer
  include JSONAPI::Serializer
  attributes :name, :ordering
  attribute :prize do |object|
    object.prize_value
  end
end
