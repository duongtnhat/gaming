class GameSerializer
  include JSONAPI::Serializer
  attribute :inst_hash
  attribute :current_pot
  attribute :status
  attribute :end_at
  attribute :created_at

  attribute :prize do |object|
    object.prize if object.done?
  end
  attribute :sand do |object|
    object.sand if object.done?
  end
  attribute :raw_hash do |object|
    ("%s%s" % [object.prize, object.sand]) if object.done?
  end
end
