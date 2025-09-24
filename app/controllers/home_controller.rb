class HomeController < ApplicationController
  before_action :set_lists

  def main
  end
  
  private
  def set_lists
    exhibitions = Exhibition.all
    @exhibitions = []
    @publications = []
    Publication.all.each { |p| @publications << p.name }
    @years = []
    exhibitions.each do |e| 
      @years << e.year if !@years.include?(e.year) 
      @exhibitions << e.name if !@exhibitions.include?(e.name) 
    end
    @years.sort!
  end
end
