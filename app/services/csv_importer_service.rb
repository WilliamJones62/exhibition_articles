# frozen_string_literal: true

# This class contains Parent creation service logic
class CsvImporterService
  def initialize(file_path, current_user_id)
    @file_path = file_path
    @current_user_id = current_user_id
  end

  def call
    CSV.foreach(@file_path, headers: true) { |row| create_records(row) }
  end

  private

  def create_records(row)
    exhibition = Exhibition.find_or_create_by(name: row['exhibition'], year: row['year']) do |exhibition|
      exhibition.user_id = @current_user_id
    end
    publication = Publication.find_or_create_by(name: row['publication']) do |publication|
      publication.publication_type = row['type']
      publication.user_id = @current_user_id
    end
    find_or_create_article(row, exhibition, publication)
  end

  def find_or_create_article(row, exhibition, publication)
    Article.find_or_create_by(title: row['title'], author: row['author'], exhibition_id: exhibition.id,
                              publication_id: publication.id) do |article|
      article.favorability = row['favorability']
      article.publication_date = row['publication_date']
      article.user_id = @current_user_id
    end
  end
end
