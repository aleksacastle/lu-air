class Calculator < ApplicationRecord
  attr_accessor :long_term_rent, :airbnb_price

  def initialize(long_term_rent, airbnb_price)
    @long_term_rent = long_term_rent
    @airbnb_price = airbnb_price
  end

  def calculate(long_term_rent, airbnb_price)
    diff = long_term_rent - airbnb_price
    if diff < 0
      puts "Congratulations! Your cooperation with Airbnb will be lucrative!"
    else
      puts "You should better consider long-term rentals!"
    end
  end
end
