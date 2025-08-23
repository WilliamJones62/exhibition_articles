class Publication < ApplicationRecord
  belongs_to :user
  has_many :articles
  has_many :exhibitions, through: :articles
end
