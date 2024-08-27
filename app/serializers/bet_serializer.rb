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
  attribute :game_win do |object|
    object.custom_info_04
  end
  attribute :win_amount do |object|
    object.custom_info_03 || "0"
  end

  attribute :created_at do |object|
    object&.game&.created_at
  end
  attribute :win_prize do |object|
    object&.game&.prize
  end
  attribute :current_pot do |object|
    object&.game&.current_pot
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
