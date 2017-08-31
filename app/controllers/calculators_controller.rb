class CalculatorsController < ApplicationController
  def create
    calc = Calculator.new(params)
    calc.calculate
  end

  private

  def params
    params.require(:calculator).permit(:long_term_rent, :airbnb_price)
  end
end
