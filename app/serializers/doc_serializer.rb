class DocSerializer
  include JSONAPI::Serializer

  attribute :action
  attribute :status
  attribute :comment
  attribute :auth_code
  attribute :ext_id
  attribute :amount
  attribute :approved_at
  attribute :created_at

  attribute :doc_type do |object|
    object&.doc_type&.code
  end
  attribute :currency do |object|
    object&.currency&.code
  end
end
