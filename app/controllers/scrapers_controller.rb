class ScrapersController < ApplicationController
  attr_accessor :country, :city, :street, :page, :long_term_rent

  def new
    @scraper = Scraper.new
  end

  def create
    # binding.pry

    @scraper = Scraper.new(scraper_params)
    # airbnb_price
    @airbnb_price = @scraper.get_price
    @result = @airbnb_price - params[:scraper][:long_term_rent].to_i
    render "show"
  end

  def show

  end

  private

  def airbnb_price
    @airbnb_price = @scraper.get_price

    @result = @airbnb_price - @long_term_rent.to_i
    render "show"
  end

  def scraper_params
    params.require(:scraper).permit(:country, :city, :street, :long_term_rent)
  end
end
