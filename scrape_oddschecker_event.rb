#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'
require 'json'

HTML_TAGS = {
  bookmakers: 'td.bookie-area a',
  bet_choices: 'tbody#t1 tr.eventTableRow',
  odds: 'tbody#t1 tr.eventTableRow td'
}

def get_bookies(page)
  bookies = []
  page.css(HTML_TAGS[:bookmakers]).each do |bookie|
    bookies << bookie["title"]
  end

  bookies.uniq!
  return bookies
end

def get_bet_choices(page)
  bet_choices = []
  page.css(HTML_TAGS[:bet_choices]).each do |choice|
    bet_choices << choice['data-bname']
  end

  return bet_choices
end

def get_odds(page)
  page.css(HTML_TAGS[:odds]).reject{|a| a.values.size==1}
end

def terminate(message)
  puts message
  exit
end

unless ARGV.length == 1
  puts 'You have not entered a link'
  exit
end

link = ARGV[0]

begin
  page = Nokogiri::HTML(open(link))
rescue
  terminate('Something went wrong during scraping. Pleach check the URL.')
end

bookies = get_bookies(page)
terminate('There is not any bookmakers') unless !bookies.empty?

bet_choices = get_bet_choices(page)
terminate('There is not any bet choices') unless !bet_choices.empty?

odds = get_odds(page)
terminate('There is not any odds') unless !odds.empty?

odds_per_bet_choice = odds.each_slice(bookies.size)

game_data = []

odds_per_bet_choice.each.with_index do |odds, index|
  odds.each_with_index do |odd, index2|
    game_data << {
      bookie: bookies[index2],
      name: bet_choices[index].downcase,
      bet_type: link.split('/').last,
      decimal_odds: odd.attributes['data-odig'].value,
      fractional_odds: odd.text
    }
  end
end

puts game_data.to_json
