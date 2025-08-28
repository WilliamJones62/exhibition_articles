# frozen_string_literal: true

# This class contains Publication logic
class Publication < ApplicationRecord
  belongs_to :user
  has_many :articles, dependent: :destroy
  has_many :exhibitions, through: :articles

  validates :name, presence: true, uniqueness: true
  validates :publication_type, presence: true
  validates :publication_type, inclusion: { in: %w[NEWSPAPER PERIODICAL] }
end
