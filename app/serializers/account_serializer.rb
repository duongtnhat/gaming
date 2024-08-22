class AccountSerializer
  include JSONAPI::Serializer
  attribute :balance
  attribute :currency_name do |object|
    object.currency.name
  end
  attribute :currency_symbol do |object|
    object.currency.name
  end
  attribute :currency_isCrypto do |object|
    object.currency.isCrypto
  end
end
