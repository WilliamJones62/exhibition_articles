# frozen_string_literal: true

# This class contains Articles controller logic
class ArticlesController < ApplicationController
  before_action :set_article, only: %i[edit update destroy]
  before_action :set_lists, only: %i[new edit create update]

  # GET /articles
  def index
    @articles = Article.order(:title)
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit; end

  # POST /articles
  def create
    @article = Article.new(article_params)
    exhibition_id, publication_id = ParentCreationService.new(params, current_user.id).call
    if !exhibition_id || !publication_id
      # something went wrong creating the exhibition or publication
      flash[:alert] = 'New Exhibition or new Publication is invalid.'
      render :new, status: :unprocessable_entity
      return
    end
    set_ids(exhibition_id, publication_id)

    if @article.save
      redirect_to articles_url, notice: 'Article was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    exhibition_id, publication_id = ParentCreationService.new(params).call
    if !exhibition_id || !publication_id
      # something went wrong creating the exhibition or publication
      flash[:alert] = 'New Exhibition or new Publication is invalid.'
      render :edit, status: :unprocessable_entity
      return
    end
    @article.exhibition_id = set_parent_id(exhibition_id, @article.exhibition_id)
    @article.publication_id = set_parent_id(publication_id, @article.publication_id)

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

  def download
    @articles = Article.all
    send_data @articles.to_csv, filename: "articles-#{Date.today}.csv"
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

  # Only allow a list of trusted parameters through.
  def article_params
    params.require(:article).permit(:title, :author, :favorability, :exhibition_id, :publication_id)
  end
end
