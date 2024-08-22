class BetSerializer
  include JSONAPI::Serializer

  attribute :currency_name do |object|
    object.currency.name
  end
  attribute :currency_symbol do |object|
    object.currency.name
  end
  attribute :currency_isCrypto do |object|
    object.currency.isCrypto
  end
  attribute :account_id do |object|
    object.account.id
  end
  attribute :bet_value do |object|
    object.custom_info_05
  end

  attribute :trans_type
  attribute :comment
  attribute :error
  attribute :ext_tran_date
  attribute :ext_tran_id
  attribute :status
  attribute :before_balance
  attribute :after_balance
  attribute :game_session
  attribute :source
  attribute :original_trans_id
  attribute :original_amount
end
