# frozen_string_literal: true
require 'csv'

# This class contains Article logic
class Article < ApplicationRecord
  belongs_to :user
  belongs_to :publication
  belongs_to :exhibition

  validates :title, presence: true
  validates :author, presence: true
  validates :favorability, presence: true
  validates :favorability, inclusion: { in: %w[FAVORABLE NEUTRAL UNFAVORABLE] }

  def self.to_csv
    column_names = %w[year exhibition publication type author title favorability]
    CSV.generate(headers: true) do |csv|
        csv << column_names
        all.each do |article|
          year = article.exhibition.year
          exhibition = article.exhibition.name
          publication = article.publication.name
          type = article.publication.publication_type
          author = article.author
          title = article.title
          favorability = article.favorability
          csv << [year, exhibition, publication, type, author, title, favorability]
        end
    end
  end
end
