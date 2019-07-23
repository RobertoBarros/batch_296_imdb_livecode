require 'open-uri'
require 'nokogiri'

def fetch_top_movie_urls
  top_movies_url = 'https://www.imdb.com/chart/top'
  html_file = open(top_movies_url).read
  html_doc = Nokogiri::HTML(html_file)

  movies_links = []
  html_doc.search('.titleColumn a').first(5).each do |link|
    movies_links << "https://www.imdb.com#{link.attribute("href").value}"
  end
  movies_links
end

def scrape_movie(url)
  html_file = open(url, "Accept-Language" => "en").read
  html_doc = Nokogiri::HTML(html_file)
  title_and_year = html_doc.search("h1").text.strip
  pattern = /(?<title>.*).\((?<year>\d{4})\)$/
  {
    title: title_and_year.match(pattern)[:title].strip,
    year: title_and_year.match(pattern)[:year].to_i,
    storyline: html_doc.search(".summary_text").text.strip,
    director: html_doc.search(".credit_summary_item a").first.text,
    cast: html_doc.search(".credit_summary_item a")[4..6].map{|item| item.text}
  }
end

