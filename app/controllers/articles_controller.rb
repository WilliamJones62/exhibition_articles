# frozen_string_literal: true

require 'csv'
# This class contains Articles controller logic
class ArticlesController < ApplicationController
  before_action :set_article, only: %i[edit update destroy]
  before_action :new_article, only: %i[new create]
  before_action :set_lists, only: %i[new edit create update]
  before_action :set_parents, only: %i[edit update]
  before_action :test_new_parents, only: %i[create update]

  # POST /articles/import
  def import
    if params[:file].present?
      CSV.foreach(params[:file].path, headers: true) { |row| create_records(row) }
      redirect_to articles_url, notice: 'CSV imported successfully!'
    else
      redirect_to articles_url, alert: 'Please upload a CSV file.'
    end
  end

  # GET /articles
  def index
    @articles = Article.order(:title)
  end

  # GET /articles/new
  def new;  end

  # GET /articles/1/edit
  def edit; end

  # POST /articles
  def create
    set_ids(@exhibition_id, @publication_id)

    if @article.save
      redirect_to articles_url, notice: 'Article was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    @article.exhibition_id = set_parent_id(@exhibition_id, @article.exhibition_id)
    @article.publication_id = set_parent_id(@publication_id, @article.publication_id)

    if @article.update(article_params)
      redirect_to articles_url, notice: 'Article was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    # authorize @article
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  def set_lists
    @favorability = %w[FAVORABLE NEUTRAL UNFAVORABLE]
    @years = AppSettings::YEARS
    @exhibitions = Exhibition.all
    @publications = Publication.all
    @publication_types = %w[NEWSPAPER PERIODICAL]
  end

  def set_ids(exhibition_id, publication_id)
    @article.exhibition_id = set_parent_id(exhibition_id, @article.exhibition_id)
    @article.publication_id = set_parent_id(publication_id, @article.publication_id)
    @article.user_id = current_user.id
  end

  def set_parent_id(new_id, current_id)
    return new_id if new_id.positive?

    current_id
  end

  def create_records(row)
    exhibition = Exhibition.find_or_create_by(name: row['exhibition'], year: row['year']) do |exhibition|
      exhibition.user_id = current_user.id
    end
    publication = Publication.find_or_create_by(name: row['publication']) do |publication|
      publication.publication_type = row['type']
      publication.user_id = current_user.id
    end
    find_or_create_article(row, exhibition, publication)
  end

  def find_or_create_article(row, exhibition, publication)
    Article.find_or_create_by(title: row['title'], author: row['author'], exhibition_id: exhibition.id,
                              publication_id: publication.id) do |article|
      article.favorability = row['favorability']
      article.user_id = current_user.id
    end
  end

  def test_new_parents
    @exhibition_id, @publication_id = ParentCreationService.new(params, current_user.id).call
    return unless !@exhibition_id || !@publication_id

    # something went wrong creating the exhibition or publication
    flash[:alert] = 'New Exhibition or new Publication is invalid.'
    render :new, status: :unprocessable_entity
    nil
  end

  def new_article
    @article = if params['action'] == 'new'
                 Article.new
               else
                 Article.new(article_params)
               end
  end

  def set_parents
    @current_exhibition = @article.exhibition
    @current_publication = @article.publication
  end

  # Only allow a list of trusted parameters through.
  def article_params
    params.require(:article).permit(:title, :author, :favorability, :exhibition_id, :publication_id)
  end
end
