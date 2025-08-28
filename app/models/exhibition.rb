# frozen_string_literal: true

# This class contains Exhibition logic
class Exhibition < ApplicationRecord
  belongs_to :user
  has_many :articles, dependent: :destroy
  has_many :publications, through: :articles

  validates :name, presence: true
  validates :year, presence: true
  validates_numericality_of :year, in: 1792..1903, only_integer: true, message: 'must be between 1792 and 1903'
  validates_uniqueness_of :name, scope: :year
end
