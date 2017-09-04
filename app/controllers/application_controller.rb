class ApplicationController < ActionController::Base
  # rescue_from Scraper
  protect_from_forgery with: :exception
end
