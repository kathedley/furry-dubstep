require 'rubygems'
require 'bundler/setup'
require 'nokogiri' #for accessing web page contents
require 'sinatra'
require 'open-uri' #for opening urls
require 'builder' #for building xmls
require 'gocardless' #for gocardless API
require 'net/http'
require 'httparty' #for post requests
require 'mandrill' #not used as using httparty for post requests to mandrill instead
require 'uri' #for escaping URLs

configure :production do
    require 'newrelic_rpm'
end


get '/' do
end


get '/lookup/:country/:lookuptype/:number' do #allPOlookup
    
    # the variables are params[:country], params[:lookuptype] and params[:number]
    
    # Setting up default response values
    http_status_code = ""
    application_number = ""
    publication_number = ""
    filing_date = ""
    status = ""
    application_title = ""
    last_renewal_date = ""
    next_renewal_date = ""
    last_renewal_year = ""
    error_message = ""
    grant_date = ""


#######################################   UK   #######################################

### not yet looked up license of right ###


    if params[:country] = "uk" #UKif1

        if #UKif2
            params[:lookuptype] == "application"
            patent_page_url = "http://www.ipo.gov.uk/p-ipsum/Case/ApplicationNumber/" + params[:number]
        elsif
            params[:lookuptype] == "publication"
            patent_page_url = "http://www.ipo.gov.uk/p-ipsum/Case/PublicationNumber/" + params[:number]
        else
            patent_page_url = ""
        end #ends UKif2

        # First, check if it's a valid page
        
        http_status_code = Net::HTTP.get_response(URI.parse(patent_page_url)).code
        
        if #if3
            http_status_code.match(/20\d/)
            
            patent_page = Nokogiri::HTML(open(patent_page_url))

            # Next, check there's a patent found at that address
            if  #UKif4
                patent_page.css("//p[@id='AsyncErrorMessage']")[0].content != ""
                
                puts "Error message exists"
                error_message = patent_page.css("//p[@id='AsyncErrorMessage']")[0].content
                puts "Message: " + error_message
                
                # Possible error messages:
                    # Please enter a valid publication number.
                    # Please enter a valid applcation number.
                    # European patent not yet granted. Check the EPO Register
                    # A case was not found matching this number.
                    # Please enter a valid publication number.
                    # The patent case type must be UK or EP(UK). e.g. PN EP0665096
                    # No data is held electronically for this case. e.g. PN GB1215686
            
            else #related to UKif4
                # No error message, continue to look for data

                # Retrieving page data: Checking if a field exists, and if so, picking up the related contents
                if  patent_page.xpath("//td[contains(text(), 'Application Number')]")[0] != nil
                    application_number = patent_page.xpath("//td[contains(text(), 'Application Number')]/following-sibling::*")[0].content
                end
                if  patent_page.xpath("//td[contains(text(), 'Publication Number')]")[0] != nil
                    publication_number = patent_page.xpath("//td[contains(text(), 'Publication Number')]/following-sibling::*")[0].content
                end
                if  patent_page.xpath("//td[contains(text(), 'Filing Date')]")[0] != nil
                    filing_date = patent_page.xpath("//td[contains(text(), 'Filing Date')]/following-sibling::*")[0].content
                end
                if  patent_page.xpath("//td[contains(text(), 'Lodged Date')]")[0] != nil
                    filing_date = patent_page.xpath("//td[contains(text(), 'Lodged Date')]/following-sibling::*")[0].content
                end
                if  patent_page.xpath("//td[contains(text(), 'Application Title')]")[0] != nil
                    application_title = patent_page.xpath("//td[contains(text(), 'Application Title')]/following-sibling::*")[0].content
                end
                if  patent_page.xpath("//td[contains(text(), 'Applicant / Proprietor')]")[0] != nil
                    applicant = patent_page.xpath("//td[contains(text(), 'Applicant / Proprietor')]/following-sibling::*")[0].content
                end
                if  patent_page.xpath("//td[contains(text(), 'Status')]")[0] != nil
                    status = patent_page.xpath("//td[contains(text(), 'Status')]/following-sibling::*")[0].content
                end
                if  patent_page.xpath("//td[contains(text(), 'Last Renewal Date')]")[0] != nil
                    last_renewal_date = patent_page.xpath("//td[contains(text(), 'Last Renewal Date')]/following-sibling::*")[0].content
                end
                if  patent_page.xpath("//td[contains(text(), 'Next Renewal Date')]")[0] != nil
                    next_renewal_date = patent_page.xpath("//td[contains(text(), 'Next Renewal Date')]/following-sibling::*")[0].content
                end
                if  patent_page.xpath("//td[contains(text(), 'Year of Last Renewal')]")[0] != nil
                    last_renewal_year = patent_page.xpath("//td[contains(text(), 'Year of Last Renewal')]/following-sibling::*")[0].content.to_i
                end
                if  patent_page.xpath("//td[contains(text(), 'Grant Date')]")[0] != nil
                    grant_date = patent_page.xpath("//td[contains(text(), 'Grant Date')]/following-sibling::*")[0].content.match(/\d{2}+\s+\w+\s+\d{4}/).to_s #finding dates by format #returns first date as string
                end
               
                #Some patents have PCT application and publication number - currently ignoring this e.g. GB2348905

                # Statuses seen:
                    # Granted                       # If renewals have been made, will have renewal-related fields e.g. PN EP2120000
                                                    # If no renewals due yet, will not have any renewal-related fields e.g. PN GB2500003
                                                    # If first renewal due, will have next renewal date e.g. PN GB2470008
                                                    # If in year 20, no next renewal date e.g. PN EP0665097
                    # Ceased                        # Still has last renewal date, next renewal date, last renewal year, also has not in force date e.g. PN GB2348901
                    # Pending                       # Does not have any renewal-related fields e.g. PN GB2500000
                                                    # May not even be published - no Publication Number field and has LODGED DATE not FILING DATE e.g. *AN* GB1215684
                    # Terminated before grant       # Has a Not in Force date e.g. PN GB2400000
                    # Awaiting First Examination    # No renewal fields as not yet granted e.g. PN GB2470002
                    # Expired                       # Over 20 years old e.g. PN EP0665079
                    # Void-no translation filed     # Not in force date e.g. PN EP0665084
                    # Application Published

            end #ends UKif4
        
        end #ends UKif3
      
    # Build XML
    xml = Builder::XmlMarkup.new(:indent=>2)
    xml.patent { |p| p.http_status_code(http_status_code); p.application_number(application_number); p.publication_number (publication_number); p.filing_date(filing_date); p.status(status); p.grant_date(grant_date); p.application_title(application_title); p.last_renewal_date(last_renewal_date); p.next_renewal_date(next_renewal_date); p.last_renewal_year(last_renewal_year); p.error_message(error_message) }
                #   Applicant not yet in XML as don't yet know how to deal with the multi-line response that arrives

    end #ends UKif1
end #ends allPOlookup




####################################   MANDRILL   ####################################

get '/mandrill/:template/:email/:fullname/:content1' do #mandrill1
    #This page sends a request to the /post page and displays the result that pages gives in a Zoho-readable XML
    
    #Setting up initial values
    mandrill_http_status_code = ""
    email_address = ""
    email_status = ""
    mandrill_email_id = ""
    
    #Escaping parameters, as they seem to turn back to standard strings when used as 'params[]'
    email_to_url = URI.escape(params[:email])
    fullname_to_url = URI.escape(params[:fullname])
    content1_to_url = URI.escape(params[:content1])
    
    mandrill_response_xml = Nokogiri::HTML(open('http://compute.renewalsdesk.com/mandrill/'+params[:template]+'/'+email_to_url+'/'+fullname_to_url+'/'+content1_to_url+'/post'))


    mandrill_http_status_code = mandrill_response_xml.xpath("//code")[0].content
    
    if mandrill_http_status_code.match(/20\d/)
        email_address = mandrill_response_xml.xpath("//email")[0].content
        email_status =  mandrill_response_xml.xpath("//status")[0].content
        mandrill_email_id = mandrill_response_xml.xpath("//_id")[0].content
    end
    
    #Build XML
    xml = Builder::XmlMarkup.new(:indent=>2)
    xml.result { |p| p.mandrill_http_status_code(mandrill_http_status_code); p.email_address(email_address); p.email_status(email_status); p.mandrill_email_id(mandrill_email_id) }


end #ends mandrill1


get '/mandrill/:template/:email/:fullname/:content1/post' do #mandrill2
    #This page actually does the post request
    
    url = 'https://mandrillapp.com/api/1.0/messages/send-template.xml'
    
    response = HTTParty.post url, :body => {"key"=>'9zTx2aQt9MAI90zqo6AyNg', # 9zTx2aQt9MAI90zqo6AyNg is a test API key
                             "template_name" => params[:template],
                             "template_content"=>
                                [{"name"=>"std_content01",
                                "content"=>params[:content1]}],
                            "message" =>
                                {"to"=>[{"type"=>"to",
                                        "email"=>params[:email],
                                        "name"=>params[:fullname]}],
                                "track_opens"=>true,
                                "important"=>false,
                                "track_clicks"=>true,
                                "auto_text"=>true,
                                "inline_css"=>true,
                                "url_strip_qs"=>true,
                                "bcc_address"=>"outbound@renewalsdesk.com",
                                "google_analytics_domains"=>["renewalsdesk.com"],
                                "google_analytics_campaign"=>[params[:template]],
                                "tags"=>["non-ar-renewal-reminder"]}, #close message
                            "result" => "mandrill.messages.send_template template_name, template_content, message"}
    
    #, #close :body
    # :headers => {"Content-Type" => "application/xml"} #close post
    
    puts response

    response.body + "<code>" + response.code.to_s + "</code>"
    

    
end #ends mandrill2
