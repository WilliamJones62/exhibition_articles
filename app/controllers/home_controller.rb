class HomeController < ApplicationController
  before_action :set_lists

  def main
  end
  
  private
  def set_lists
    @exhibitions = Exhibition.all
    @publications = Publication.all
    @years = []
    @exhibitions.each { |e| @years << e.year if !@years.include?(e.year) }
    @years.sort!
  end
end
