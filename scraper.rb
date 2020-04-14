require 'nokogiri'
require 'httparty'

def remove_special( str )

  accents = { ['á', 'Á', 'Ã', 'ã' ] => 'a',
          ['é' , 'É', 'ẽ', 'Ẽ' ] => 'e',
          ['i', 'Í'] => 'i',
          ['o', 'Ó', 'õ', 'Õ' ] => 'o',
          ['ú', 'Ú' ] => 'u'
            }

  accents.each do |ac,rep|
    ac.each do |s|
      str.gsub!(s, rep)
    end
  end

return str

end


def scraper
  
  input = gets.strip
  jobs = Array.new
  search = Array.new
  page = 1
  last = 2
  
  param = remove_special(input).downcase


  while page <= last
    pagination_url = "https://empregacampinas.com.br/categoria/vaga/page/#{page}"
    puts pagination_url
    puts "page: #{page}"
    pagination_unparsed_page = HTTParty.get(pagination_url)
    pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
    pagination_job_listing = pagination_parsed_page.css('a.thumbnail')
    
    pagination_job_listing.each do |job_listing|
      job = {
      title: job_listing.css("h2").text,
      date: job_listing.css("span.time").text
    }
      normalized = remove_special(job_listing.css("h2").text.downcase)
      if normalized.include?(param)
        search << job_listing.css("h2").text
      end
    day = job[:date].split(" ")
    date_now = Time.now 
    last = date_now.day.to_i - day[1].to_i #supposed to sarch until next day
    end

    page += 1
  end

  search.each do |s|
    puts s
  end
 end

 scraper
