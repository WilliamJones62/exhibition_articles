# frozen_string_literal: true

module Api
  module V1
    # This class contains Reports controller logic
    class ReportsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :set_params

      FAVORTEXT = %w[FAVORABLE NEUTRAL UNFAVORABLE].freeze
      FAVORINT = [2, 1, 0].freeze

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
        exhibitions = Exhibition.where(year: @year)
        exhibitions.each do |exhibition|
          @xvalues << exhibition.name
          @yvalues << exhibition.articles.count
        end
      end

      def linegraph
        @xvalues = (1792..1903).to_a
        @yvalues = []
        @xvalues.each do |y|
          articles_ctr = 0
          exhibitions = Exhibition.where(year: y).where(name: @exhibitions)
          exhibitions.each { |e| articles_ctr += e.articles.count }
          @yvalues << articles_ctr
        end
      end

      private

      def set_params
        puts "params = #{params}"
        @year = params[:year] if params[:year]
        @exhibitions = params[:exhibitions].split(',') if params[:exhibitions]
      end

      def calculate_favorability(exhibition)
        articles = exhibition.articles.all
        favor = 0
        articles.each { |a| favor += FAVORINT[FAVORTEXT.index(a.favorability)] }
        return 0 if articles.length == 0
        ((favor.to_f / articles.length) * 50).round
      end
    end
  end
end
