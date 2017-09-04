class ScrapersController < ApplicationController
  attr_accessor :country, :city, :street, :page, :long_term_rent

  def new
    @scraper = Scraper.new(:country, :city, :street)
  end

  def create
    @scraper = Scraper.new(:country, :city, :street)
    if @scraper.save
      render show
    else
      render new
    end

    # @airbnb_price = @scraper.get_price
  end

  def show
    @airbnb_price = @scraper.get_price

    @result = @airbnb_price - @long_term_rent
  end
  
  private

  def scraper_params
    params.require(Scraper.new).permit(:country, :city, :street, :long_term_rent)
  end
end
