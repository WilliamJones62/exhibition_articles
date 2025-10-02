# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvImporterService, type: :service do
  let!(:user) { create(:user) }

  # before do
  #   sign_in user
  # end

  let!(:exhibition) { create(:exhibition, user: user) }
  let!(:publication) { create(:publication, user: user) }
  let!(:article1) { create(:article, user: user, exhibition: exhibition, publication: publication) }
  let!(:article2) { create(:article, user: user, exhibition: exhibition, publication: publication) }

  describe 'import' do
    let(:csv_data) do
      formatted_date = article1.publication_date.strftime('%Y-%m-%d') # YYYY-MM-DD format
      CSV.generate do |csv|
        csv << %w[year exhibition publication type author title favorability
                  publication_date]
        csv << [exhibition.year.to_s, 'Exhibition 1', 'Publication 1', publication.publication_type,
                article1.author, 'Article 1', article1.favorability, formatted_date]
        csv << [exhibition.year.to_s, 'Exhibition 2', 'Publication 2', publication.publication_type,
                article2.author, 'Article 2', article2.favorability, formatted_date]
      end
    end
    let(:file_path) { 'tmp/test_import.csv' }

    before do
      File.write(file_path, csv_data)
    end

    after do
      File.delete(file_path) if File.exist?(file_path)
    end

    it 'creates new records from valid CSV data' do
      expect do
        CsvImporterService.new(file_path, user.id).call
      end.to change(Article, :count).by(2)
      expect(Article.last.title).to eq('Article 2')
    end
  end
end
