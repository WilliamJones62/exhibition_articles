# frozen_string_literal: true

# This class contains Parent creation service logic
class ParentCreationService
  def initialize(params, current_user_id)
    @params = params
    @current_user_id = current_user_id
  end

  def call
    [exhibition_create, publication_create]
  end

  private

  def exhibition_create
    if !@params['article']['exhibition_year'].blank? || !@params['article']['exhibition_name'].blank?
      exhibition = new_exhibition
      unless exhibition.save
        # Can't create this exhibition for some reason
        return false
      end

      return exhibition.id
    end
    0
  end

  def new_exhibition
    exhibition = Exhibition.new
    exhibition.name = @params['article']['exhibition_name']
    exhibition.year = @params['article']['exhibition_year']
    exhibition.user_id = @current_user_id
    exhibition
  end

  def publication_create
    if !@params['article']['publication_name'].blank? || !@params['article']['publication_type'].blank?
      publication = new_publication
      unless publication.save
        # Can't create this publication for some reason
        return false
      end

      return publication.id
    end
    0
  end

  def new_publication
    publication = Publication.new
    publication.name = @params['article']['publication_name']
    publication.publication_type = @params['article']['publication_type']
    publication.user_id = @current_user_id
    publication
  end
end
