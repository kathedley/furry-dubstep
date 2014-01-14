require 'rubygems'
require 'bundler/setup'

require 'nokogiri'
require 'sinatra'
require 'open-uri'
require 'builder'

get '/uk/publication/:pub_number' do
    # the variable is params[:pub_number]

#"Hello #{params[:pub_number]} world!"



    patent_page_url = "http://www.ipo.gov.uk/p-ipsum/Case/PublicationNumber/" + params[:pub_number]
    patent_page = Nokogiri::HTML(open(patent_page_url))

# need to handle 404 error (and others)

    application_title = patent_page.xpath("//td[contains(text(), 'Application Title')]/following-sibling::*")[0].content

    status = patent_page.xpath("//td[contains(text(), 'Status')]/following-sibling::*")[0].content

    #puts "Application Title: " + application_title
    #puts "Status: " + status
    
    if status == 'Granted'
        last_renewal_date = patent_page.xpath("//td[contains(text(), 'Last Renewal Date')]/following-sibling::*")[0].content
        
        next_renewal_date = patent_page.xpath("//td[contains(text(), 'Next Renewal Date')]/following-sibling::*")[0].content
        
        last_renewal_year = patent_page.xpath("//td[contains(text(), 'Year of Last Renewal')]/following-sibling::*")[0].content.to_i
        
        next_renewal_year = last_renewal_year + 1
        
        
        fee = [ 0,0,0,0, 70.00, 90.00, 110.00, 130.00, 150.00, 170.00, 190.00, 210.00, 250.00, 290.00, 350.00, 410.00 ,460.00, 510.00, 560.00, 600.00]
        
        
        #puts "Last Renewal Date: " + last_renewal_date
        #puts "Next Renewal Date: " + next_renewal_date
        #puts "Year of Renewal Due: " + next_renewal_year.to_s
        #puts "Fee: GBP " + fee[next_renewal_year - 1].to_s


    else
        last_renewal_date = ""
        next_renewal_date = ""
        last_renewal_year = 0
    end

    
    xml = Builder::XmlMarkup.new(:indent=>2)
    xml.patent { |p| p.status(status); p.application_title(application_title); p.last_renewal_date(last_renewal_date); p.next_renewal_date(next_renewal_date); p.last_renewal_year(last_renewal_year) }

end