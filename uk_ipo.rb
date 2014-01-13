require 'rubygems'
require 'bundler/setup'

require 'nokogiri'
require 'rest-open-uri'
require 'sinatra'

get '/uk/publication_number/:pub_number' do
    # params[:pub_number] is the parameter

#puts "Enter the UK publication number - use EP2120000 (granted), GB2394569 (granted) or GB2234567 (terminated before grant)"
#pub_number = gets

patent_page_url = "http://www.ipo.gov.uk/p-ipsum/Case/PublicationNumber/" + params[:pub_number]

patent_page = Nokogiri::HTML(open(patent_page_url))

# need to handle 404 error (and others)

application_title = patent_page.xpath("//td[contains(text(), 'Application Title')]/following-sibling::*")[0].content

status = patent_page.xpath("//td[contains(text(), 'Status')]/following-sibling::*")[0].content

puts "Application Title: " + application_title
puts "Status: " + status

if status == 'Granted'
    last_renewal_date = patent_page.xpath("//td[contains(text(), 'Last Renewal Date')]/following-sibling::*")[0].content
    
    next_renewal_date = patent_page.xpath("//td[contains(text(), 'Next Renewal Date')]/following-sibling::*")[0].content

    last_renewal_year = patent_page.xpath("//td[contains(text(), 'Year of Last Renewal')]/following-sibling::*")[0].content.to_i
    
    next_renewal_year = last_renewal_year + 1
    

fee = [ 0,0,0,0, 70.00, 90.00, 110.00, 130.00, 150.00, 170.00, 190.00, 210.00, 250.00, 290.00, 350.00, 410.00 ,460.00, 510.00, 560.00, 600.00]


    puts "Last Renewal Date: " + last_renewal_date
    puts "Next Renewal Date: " + next_renewal_date
    puts "Year of Renewal Due: " + next_renewal_year.to_s
    puts "Fee: GBP " + fee[next_renewal_year - 1].to_s

end