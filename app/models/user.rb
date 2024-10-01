class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :api
  has_many :accounts

  enum :role, {admin: "admin", ops: "ops"}
end
