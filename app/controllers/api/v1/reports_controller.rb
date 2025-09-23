class Api::V1::ReportsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_params

  FAVORTEXT = ["FAVORABLE", "NEUTRAL", "UNFAVORABLE"]
  FAVORINT = [2, 1, 0]

  def barchart
    @xvalues = []
    @yvalues = []
    exhibitions = Exhibition.where(year: @year)
    exhibitions.each do |exhibition|
      @xvalues << exhibition.name
      @yvalues << calculate_favorability(exhibition)
    end
  end

  def piechart
    @xvalues = []
    @yvalues = []
  end

  def linegraph
    @xvalues = []
    @yvalues = []
  end

  private
  def set_params
    @year = params[:year] if params[:year]
    @exhibition = params[:exhibition] if params[:exhibition]
    @publication = params[:publication] if params[:publication]
  end

  def calculate_favorability(exhibition)
    articles = exhibition.articles.all
    favor = 0
    articles.each { |a| favor += FAVORINT[FAVORTEXT.index(a.favorability)] }
    ((favor.to_f / articles.length) * 50).round
  end
end
