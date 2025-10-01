# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Articles', type: :request do
  let!(:user) { create(:user) }

  before do
    sign_in user
  end

  let!(:exhibition) { create(:exhibition, user: user) }
  let!(:publication) { create(:publication, user: user) }
  let!(:article1) { create(:article, user: user, exhibition: exhibition, publication: publication) }
  let!(:article2) { create(:article, user: user, exhibition: exhibition, publication: publication) }

  describe '#import' do
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

  describe 'GET /articles' do
    it 'returns a successful response' do
      get articles_path
      expect(response).to have_http_status(:ok)
    end
    it 'assigns all articles' do
      get articles_path
      expect(assigns(:articles)).to match_array([article1, article2])
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get new_article_path
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new instance of MyModel' do
      get new_article_path
      expect(assigns(:article)).to be_a_new(Article)
    end
  end

  describe "POST #create" do
    before do
      @article_attributes = FactoryBot.attributes_for(:article)
      @article_attributes[:user_id] = user.id 
      @article_attributes[:exhibition_id] = exhibition.id 
      @article_attributes[:publication_id] = publication.id 
    end
    context "with valid parameters" do
      it "creates a new Article" do
        expect {
          post articles_path, params: { article: @article_attributes }
        }.to change(Article, :count).by(1)
      end

      it "redirects to the created article" do
        post articles_path, params: { article: @article_attributes }
        expect(response).to redirect_to(articles_url)
      end

      it "sets a success flash message" do
        post articles_path, params: { article: @article_attributes }
        expect(flash[:notice]).to eq("Article was successfully created.")
      end
    end

    context "with invalid parameters" do
      before do
        @article_attributes[:title] = nil
      end

      it "does not create a new Article" do
        expect {
          post articles_path, params: { article: @article_attributes }
        }.to_not change(Article, :count)
      end

      it "re-renders the 'new' template" do
        post articles_path, params: { article: @article_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET /article/:id/edit' do
    it 'renders a successful response' do
      get edit_article_path(article1)
      expect(response).to be_successful
    end

    it 'assigns the requested resource to @article' do
      get edit_article_path(article1)
      expect(assigns(:article)).to eq(article1)
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) { { title: 'Updated Name', author: 'New Author', favorability: 'FAVORABLE', publication_date: '1900-01-01', user_id: user.id, exhibition_id: exhibition.id, publication_id: publication.id } }

      it 'updates the requested article' do
        put article_url(article1.id), params: { id: article1.id, article: new_attributes }
        article1.reload
        expect(article1.title).to eq('Updated Name')
        expect(article1.author).to eq('New Author')
      end

      it 'redirects to the index' do
        put article_url(article1.id), params: { id: article1.id, article: new_attributes }
        expect(article1).to redirect_to(articles_url)
      end

      it 'sets a flash notice' do
        put article_url(article1.id), params: { id: article1.id, article: new_attributes }
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { title: '' } } 

      it 'does not update the article' do
        original_title = article1.title
        put article_url(article1.id), params: { id: article1.id, article: invalid_attributes }
        article1.reload
        expect(article1.title).to eq(original_title)
      end

      it 'renders the :edit template' do
        put article_url(article1.id), params: { id: article1.id, article: invalid_attributes }
        expect(article1).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /article/:id' do
    context 'when the resource exists' do
      it 'destroys the specified resource' do
        expect do
          delete article_path(article1)
        end.to change(Article, :count).by(-1)
      end
    end
  end
end
