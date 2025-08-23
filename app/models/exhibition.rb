class Exhibition < ApplicationRecord
  belongs_to :user
  has_many :articles
  has_many :publications, through: :articles
end
