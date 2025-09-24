# frozen_string_literal: true

# This class contains Home controller logic
class HomeController < ApplicationController
  before_action :set_lists

  def main; end

  private

  def set_lists
    exhibitions = Exhibition.all
    @exhibitions = []
    @publications = []
    Publication.all.each { |p| @publications << p.name }
    @years = []
    exhibitions.each do |e|
      @years << e.year unless @years.include?(e.year)
      @exhibitions << e.name unless @exhibitions.include?(e.name)
    end
    @years.sort!
  end
end
