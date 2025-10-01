# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home', type: :request do
  let!(:user) { create(:user) }
  let!(:exhibition) { create(:exhibition, user: user) }
  let!(:publication) { create(:publication, user: user) }
  let!(:article1) { create(:article, user: user, exhibition: exhibition, publication: publication) }
  let!(:article2) { create(:article, user: user, exhibition: exhibition, publication: publication) }

  describe 'GET /main' do
    it 'returns a successful response' do
      get home_main_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #download_csv' do
    it 'downloads a CSV file with correct content' do
      get home_download_path
      expect(response.headers['Content-Disposition']).to include('attachment; filename="articles-')
      expect(response.content_type).to eq('text/csv')

      csv_data = CSV.parse(response.body)
      # Assert on the content of the CSV data
      formatted_date = article1.publication_date.strftime('%Y-%m-%d') # YYYY-MM-DD format
      expect(csv_data[0]).to eq(%w[year exhibition publication type author title favorability
                                   publication_date])
      expect(csv_data[1]).to eq([exhibition.year.to_s, exhibition.name, publication.name, publication.publication_type,
                                 article1.author, article1.title, article1.favorability, formatted_date])
    end
  end
end
