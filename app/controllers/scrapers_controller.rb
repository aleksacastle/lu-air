class ScrapersController < ApplicationController
  def new
    @scraper = Scraper.new
  end

  def create
    @scraper = Scraper.new(scraper_params)
    airbnb_price(@scraper)

    render "show"
  end

  private

  def airbnb_price(scraper)
    airbnb        = scraper.get_airbnb
    @airbnb_price = airbnb[:price]
    @currency     = airbnb[:currency]
    @result       = @airbnb_price - long_term_rent(scraper)
  end

  def long_term_rent(scraper)
    params[:scraper][:long_term_rent].to_i
  end

  def scraper_params
    params.require(:scraper).permit(:country, :city, :street, :long_term_rent)
  end
end
