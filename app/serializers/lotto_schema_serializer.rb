class LottoSchemaSerializer
  include JSONAPI::Serializer
  attributes :name, :code, :price, :range_from, :range_to, :win_number, :duplicate
end
