# frozen_string_literal: true

# This class contains Publications controller logic
class PublicationsController < ApplicationController
  before_action :set_publication, only: %i[edit update destroy]
  def index
    @publications = Publication.order(:name)
  end

  def edit
    @all_exhibitions = Exhibition.all
    @selected_exhibitions = []
    current_exhibitions = @publication.exhibitions
    current_exhibitions.each do |ce|
      @selected_exhibitions.push(ce.id)
    end
  end

  def update
    if @publication.update(publication_params)
      redirect_to publications_url, notice: 'publication was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    #   authorize @publication
    @publication.destroy
    redirect_to publications_url, notice: 'publication was successfully deleted'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_publication
    @publication = Publication.find(params[:id])
    @publication_types = %w[NEWSPAPER PERIODICAL]
  end

  # Only allow a list of trusted parameters through.
  def publication_params
    params.require(:publication).permit(:name, :publication_type)
  end
end
