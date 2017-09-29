require 'nokogiri'
require 'open-uri'

class Scraper
  PRICE_CSS      = 'div.ellipsized_1iurgbx[data-reactid] span.text_5mbkop-o_O-size_small_1gg2mc-o_O-weight_bold_153t78d-o_O-inline_g86r3e[data-reactid] span[data-reactid]'.freeze
  PAGINATION_CSS = 'ul.buttonList_11hau3k li.buttonContainer_1am0dt a.link_1ko8une'.freeze
  BASE_URL       = 'https://airbnb.com/s/'.freeze
  GUESTS         = '/?guests=2'.freeze
  MONTH          = 30

  def initialize(hash)
    @currency = ''
    @city     = hash[:city]
    @street   = hash[:street]
    @country  = hash[:country]
    @url      = BASE_URL       +
                gsub(@street)  + '--' +
                gsub(@city)    + '--' +
                gsub(@country) +
                GUESTS
  end

  def get_airbnb
    page = Nokogiri::HTML(open(@url, 'User-Agent' => "Ruby/#{RUBY_VERSION}"))

    # Scrape the max number of pages and store in max_page variable
    page_numbers = []
    page.css(PAGINATION_CSS).each do |line|
      page_numbers << line.text
    end
    page_numbers = page_numbers.map(&:to_i)
    max_page     = page_numbers.max

    # Initialize empty arrays
    price_name = []
    price      = []
    name       = []

    # Loop once for every page of search results
    max_page.times do |i|
      # Open search results page
      url  = @url + "?section offset=#{i}"
      page = Nokogiri::HTML(open(url, 'User-Agent' => "Ruby/#{RUBY_VERSION}"))

      # Find all properties (Name - Price)
      page.css(PRICE_CSS).each do |line|
        name << line.text.strip
      end
    end

    # Delete word Price from array
    name -= %w[Price]
    # binding.pry
    # seperate price from name
    name.each do |n|
      price_name << n if name.index(n).even?
    end

    # seperate currency
    currency = price_name[0].chr

    # parse price array from string to integer
    price_name.each do |p|
      p.delete!(currency)
      p.delete!(',') if p.include?(',')
      price << p.to_i
    end

    # calculating average price
    sum_price = price.inject { |sum, p| sum + p }
    count_rooms = price.length
    airbnb_price = sum_price / count_rooms * MONTH

    { currency: currency, price: airbnb_price }
  end

  private

  def gsub(string)
    string.gsub(/\s/, '-')
  end
end
