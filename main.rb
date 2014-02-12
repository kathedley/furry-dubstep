require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'sinatra'
require 'open-uri'
require 'builder'
require 'gocardless'
require 'net/http'
require 'mandrill'

configure :production do
    require 'newrelic_rpm'
end


get '/' do
end


####################################   MANDRILL   ####################################
### ###
get '/mandrill/:template/:email/:fullname/:content1/' do #mandrill1
    
    begin #mandrill2
        mandrill = Mandrill::API.new '9zTx2aQt9MAI90zqo6AyNg' # this is a test API key
        template_name = params[:template]
        template_content = [{"std_content01"=>params[:content1]}]
        message = {"to"=>
            [{"type"=>"to",
                "email"=>params[:email],
                "name"=>params[:fullname]}],
            "track_opens"=>true,
            "important"=>false,
            "track_clicks"=>true,
            "auto_text"=>true,
            "inline_css"=>true,
            #"url_strip_qs"=>nil, #strips parameters from urls, so tracked clicks aggregate
            "bcc_address"=>"outbound@renewalsdesk.com",
            "google_analytics_domains"=>["renewalsdesk.com"],
            "google_analytics_campaign"=>[params[:template]],
            "tags"=>["non-ar-renewal-reminder"]}
            #"auto_html"=>nil}
        async = false
        result = mandrill.messages.send_template template_name, template_content, message, async, ip_pool, send_at
        # [{"_id"=>"abc123abc123abc123abc123abc123",
        #     "status"=>"sent",
        #     "reject_reason"=>"hard-bounce",
        #     "email"=>"recipient.email@example.com"}]
        
        rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        puts "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
        raise
    end #ends begin mandrill2
    
end #ends do mandrill1



##################################   GO CARDLESS   ##################################

# Initialising GoCardless client
GoCardless.environment = :sandbox
GoCardless.account_details = {
    :app_id => '92JE8HYRG8NPC1ZJXMSBQ59BD2S0D0R6TGXSD5ZM971AFWMJZ1C7DSAPHXN1PABQ',
    :app_secret => 'AYTVNMFAV89Y8QWJT7CQGA4Q62WT7TC7G9QMGXVTAS34WRKMY48JM82HHP183XJC',
    :token => 'AYSHQRK99Y40G33QA2A1BVEY7ET90FK4675R8GGZ3B794SEXNWKSK2VMWFK24ZST',
    :merchant_id => '0HECHG47YP',
}


get '/gc/:email/subscribe' do #do1
    
    # We'll be billing everyone £10 per month
    # for a premium subscription
    url_params = {
        :amount => 10,
        :interval_unit => "month",
        :interval_length => 2,
        :name => "Premium Subscription",
        # Set the user email from the submitted value
        :user => {
            :email => params[:email]
        }
    }
    
    url = GoCardless.new_subscription_url(url_params)
    redirect url
    print url
end #ends do1

get '/confirm' do #do2
    begin GoCardless.confirm_resource(params) #begin1
        "New subscription created!"
        rescue GoCardless::ApiError => e
        @error = e
        "Could not confirm new subscription. Details: #{e}"
    end #ends begin1
end #ends do2

get '/lookup/:country/:lookuptype/:number' do #do3
    
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


#######################################   UK   #######################################

### not yet looked up license of right ###


    if params[:country] = "uk" #if1

        if #if2
            params[:lookuptype] == "application"
            patent_page_url = "http://www.ipo.gov.uk/p-ipsum/Case/ApplicationNumber/" + params[:number]
        elsif
            params[:lookuptype] == "publication"
            patent_page_url = "http://www.ipo.gov.uk/p-ipsum/Case/PublicationNumber/" + params[:number]
        else
            patent_page_url = ""
        end #ends if2

        # First, check if it's a valid page
        
        http_status_code = Net::HTTP.get_response(URI.parse(patent_page_url)).code
        
        if #if3
            http_status_code.match(/20\d/)
            
            patent_page = Nokogiri::HTML(open(patent_page_url))

            # Next, check there's a patent found at that address
            if  #if4
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
            
            else #related to if4
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

            end #ends if4
        
        end #ends if3
      
    # Build XML
    xml = Builder::XmlMarkup.new(:indent=>2)
    xml.patent { |p| p.http_status_code(http_status_code); p.application_number(application_number); p.publication_number (publication_number); p.filing_date(filing_date); p.status(status); p.grant_date(grant_date); p.application_title(application_title); p.last_renewal_date(last_renewal_date); p.next_renewal_date(next_renewal_date); p.last_renewal_year(last_renewal_year); p.error_message(error_message) }
                #   Applicant not yet in XML as don't yet know how to deal with the multi-line response that arrives

    end #ends if1
end #ends do3