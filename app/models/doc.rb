class Doc < ApplicationRecord
  belongs_to :doc_type
  belongs_to :user
  belongs_to :currency
end
