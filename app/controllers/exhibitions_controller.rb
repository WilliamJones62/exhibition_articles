# frozen_string_literal: true

# This class contains Exhibitions controller logic
class ExhibitionsController < ApplicationController
  before_action :set_exhibition, only: %i[edit update destroy]
  before_action :set_lists, only: %i[edit]

  def index
    # @exhibitions = Exhibition.all
    @exhibitions = Exhibition.order(:name)
  end

  def edit
    #   authorize @exhibition
    @current_year = @exhibition.year
  end

  def update
    #   authorize @exhibition
    @exhibition.exhibitionyears.delete_all
    params[:years][:id].each do |year|
      @exhibition.exhibitionyears.build(year_id: year) unless year.empty?
    end

    if @exhibition.update(exhibition_params)
      redirect_to exhibitions_url, notice: 'Exhibition was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    #   authorize @exhibition
    @exhibition.destroy
    redirect_to exhibitions_url, notice: 'Exhibition was successfully deleted'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exhibition
    @exhibition = Exhibition.find(params[:id])
  end

  def set_lists
    @years = AppSettings::YEARS
  end

  # Only allow a list of trusted parameters through.
  def exhibition_params
    params.require(:exhibition).permit(:name, :exhibition_date)
  end
end
