require 'nokogiri'
require 'open-uri'

# class for scraping given address on airbnb page and fetching average price
class Scraper
  attr_accessor :country, :city, :street, :page, :currency

  BASE_URL = 'https://airbnb.com/s/'.freeze
  GUESTS = '/?guests=2'.freeze
  MONTH = 30.freeze

  def initialize(hash)
    @country = hash[:country]
    @city = hash[:city]
    @street = hash[:street]
    @currency = currency
    @url = BASE_URL +
           @street.gsub(/\s/,"-") + '--' + @city.gsub(/\s/,"-") + '--' + @country.gsub(/\s/,"-") +
           GUESTS
  end

  def get_price
    page = Nokogiri::HTML(open(@url, 'User-Agent' => "Ruby/#{RUBY_VERSION}"))

    # Scrape the max number of pages and store in max_page variable
    page_numbers = []
    page.css('ul.buttonList_11hau3k li.buttonContainer_1am0dt a.link_1ko8une').each do |line|
      page_numbers << line.text
    end
    page_numbers = page_numbers.map(&:to_i)
    max_page = page_numbers.max

    # Initialize empty arrays
    name = []
    price_name = []
    price = []

    # Loop once for every page of search results
    max_page.times do |i|
      # Open search results page
      url = @url + "?section offset=#{i}"
      page = Nokogiri::HTML(open(url, 'User-Agent' => "Ruby/#{RUBY_VERSION}"))

      # Find all properties (Name - Price)
      page.css('div.ellipsized_1iurgbx[data-reactid] span.text_5mbkop-o_O-size_small_1gg2mc-o_O-weight_bold_153t78d-o_O-inline_g86r3e[data-reactid] span[data-reactid]').each do |line|
        name << line.text.strip
      end
    end

    # Delete word Price from array
    name -= %w[Price]

    # seperate price from name
    name.each do |n|
      price_name << n if name.index(n).even?
    end

    # seperate currency
    @currency = price_name[0].chr

    # parse price array from string to integer
    price_name.each do |p|
      p.delete!(currency)
      p.delete!(',') if p.include?(',')
      price << p.to_i
    end

    # calculating average price
    sum_price = price.inject { |sum, p| sum + p }
    count_rooms = price.length
    average_price = sum_price / count_rooms
    average_price * MONTH
  end
end
