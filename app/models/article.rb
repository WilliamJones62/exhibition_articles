# frozen_string_literal: true

# This class contains Article logic
class Article < ApplicationRecord
  belongs_to :user
  belongs_to :publication
  belongs_to :exhibition

  validates :title, presence: true
  validates :author, presence: true
  validates :favorability, presence: true
  validates :favorability, inclusion: { in: %w[FAVORABLE NEUTRAL UNFAVORABLE] }
end
