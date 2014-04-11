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
    lodged_date = ""
    status = ""
    application_title = ""
    applicant_name = ""
    applicant_line_1 = ""
    applicant_address = ""
    applicant_line_2 = ""
    applicant_line_3 = ""
    applicant_line_4 = ""
    applicant_line_5 = ""
    applicant_line_6 = ""
    applicant_line_7 = ""
    applicant_line_8 = ""
    applicant_line_9 = ""
    applicant_line_10 = ""
    applicant_line_11 = ""
    applicant_line_12 = ""
    applicant_line_13 = ""
    applicant_line_14 = ""
    applicant_line_15 = ""
    applicant_line_16 = ""
    applicant_line_17 = ""
    applicant_line_18 = ""
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
                
                logger.info "Error message returned!\n"
                error_message = patent_page.css("//p[@id='AsyncErrorMessage']")[0].content
                logger.info "Message: " + error_message + "\n"
                
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
                logger.info "Data returned!\n"
                # Retrieving page data: Checking if a field exists, and if so, picking up the related contents
                if  patent_page.xpath("//td[contains(text(), 'Application Number')]")[0] != nil
                    application_number = patent_page.xpath("//td[contains(text(), 'Application Number')]/following-sibling::*")[0].content
                    logger.info "Application Number: " + application_number + "\n"
                end
                if  patent_page.xpath("//td[contains(text(), 'Publication Number')]")[0] != nil
                    publication_number = patent_page.xpath("//td[contains(text(), 'Publication Number')]/following-sibling::*")[0].content
                    logger.info "Publication Number: " + publication_number + "\n"
                end
                if  patent_page.xpath("//td[contains(text(), 'Filing Date')]")[0] != nil
                    filing_date = patent_page.xpath("//td[contains(text(), 'Filing Date')]/following-sibling::*")[0].content
                    logger.info "Filing Date: " + filing_date + "\n"
                end
                if  patent_page.xpath("//td[contains(text(), 'Lodged Date')]")[0] != nil
                    lodged_date = patent_page.xpath("//td[contains(text(), 'Lodged Date')]/following-sibling::*")[0].content
                    logger.info "Lodged Date: " + lodged_date + "\n"
                end
                if  patent_page.xpath("//td[contains(text(), 'Application Title')]")[0] != nil
                    application_title = patent_page.xpath("//td[contains(text(), 'Application Title')]/following-sibling::*")[0].content
                    logger.info "Application Title: " + application_title + "\n"
                end
                if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]")[0] != nil
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[1]")[0] !=nil
                        applicant_line_1 = patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[1]")[0].content
                        applicant_name = applicant_line_1
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[2]")[0] !=nil
                        applicant_line_2 = patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[2]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[3]")[0] !=nil
                        applicant_line_3 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[3]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[4]")[0] !=nil
                        applicant_line_4 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[4]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[5]")[0] !=nil
                        applicant_line_5 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[5]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[6]")[0] !=nil
                        applicant_line_6 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[6]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[7]")[0] !=nil
                        applicant_line_7 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[7]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[8]")[0] !=nil
                        applicant_line_8 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[8]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[9]")[0] !=nil
                        applicant_line_9 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[9]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[10]")[0] !=nil
                        applicant_line_10 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[10]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[11]")[0] !=nil
                        applicant_line_11 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[11]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[12]")[0] !=nil
                        applicant_line_12 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[12]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[13]")[0] !=nil
                        applicant_line_13 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[13]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[14]")[0] !=nil
                        applicant_line_14 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[14]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[15]")[0] !=nil
                        applicant_line_15 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[15]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[16]")[0] !=nil
                        applicant_line_16 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[16]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[17]")[0] !=nil
                        applicant_line_17 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[17]")[0].content
                    end
                    if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[18]")[0] !=nil
                        applicant_line_18 = ", " + patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[18]")[0].content
                    end
        
                    applicant_address = applicant_line_2 + applicant_line_3 + applicant_line_4 + applicant_line_5 + applicant_line_6 + applicant_line_7 + applicant_line_8 + applicant_line_9  + applicant_line_10  + applicant_line_11  + applicant_line_12  + applicant_line_13  + applicant_line_14  + applicant_line_15  + applicant_line_16  + applicant_line_17  + applicant_line_18
                    
                    logger.info "Applicant Name: " + applicant_name + "\n"
                    logger.info "Applicant Address: " + applicant_address + "\n"
                end
                if  patent_page.xpath("//td[contains(text(), 'Status')]")[0] != nil
                    status = patent_page.xpath("//td[contains(text(), 'Status')]/following-sibling::*")[0].content
                    logger.info "Status: " + status + "\n"
                end
                if  patent_page.xpath("//td[contains(text(), 'Last Renewal Date')]")[0] != nil
                    last_renewal_date = patent_page.xpath("//td[contains(text(), 'Last Renewal Date')]/following-sibling::*")[0].content
                    logger.info "Last Renewal Date: " + last_renewal_date + "\n"
                end
                if  patent_page.xpath("//td[contains(text(), 'Next Renewal Date')]")[0] != nil
                    next_renewal_date = patent_page.xpath("//td[contains(text(), 'Next Renewal Date')]/following-sibling::*")[0].content
                    logger.info "Next Renewal Year: " + next_renewal_date + "\n"
                end
                if  patent_page.xpath("//td[contains(text(), 'Year of Last Renewal')]")[0] != nil
                    last_renewal_year = patent_page.xpath("//td[contains(text(), 'Year of Last Renewal')]/following-sibling::*")[0].content.to_i
                    logger.info "Last Renewal Year: " + last_renewal_year.to_s + "\n"
                end
                if  patent_page.xpath("//td[contains(text(), 'Grant Date')]")[0] != nil
                    grant_date = patent_page.xpath("//td[contains(text(), 'Grant Date')]/following-sibling::*")[0].content.match(/\d{2}+\s+\w+\s+\d{4}/).to_s #finding dates by format #returns first date as string
                    logger.info "Grant Date: " + grant_date + "\n"
                end
               
                #Some patents have PCT application and publication number - currently ignoring this e.g. GB2348905

                # Statuses seen:
                    # Granted                       # If renewals have been made, will have renewal-related fields e.g. PN EP2120000
                                                    # If no renewals due yet, will not have any renewal-related fields e.g. PN GB2500003
                                                    # If first renewal due, will have next renewal date e.g. PN GB2470008
                                                    # If in year 20, no next renewal date e.g. PN EP0665097
                    # Ceased                        # Still has last renewal date, next renewal date, last renewal year, also has not in force date e.g. PN GB2348901
                    # Pending                       # Does not have any renewal-related fields e.g. PN GB2500000
                                                    # May not even be published - no Publication Number field and has LODGED DATE not FILING DATE
                    # Terminated before grant       # Has a Not in Force date e.g. PN GB2400000
                    # Awaiting First Examination    # No renewal fields as not yet granted e.g. PN GB2470002
                    # Expired                       # Over 20 years old e.g. PN EP0665079
                    # Void-no translation filed     # Not in force date e.g. PN EP0665084
                    # Application Published

            end #ends UKif4
        
        end #ends UKif3
      
    # Build XML
    xml = Builder::XmlMarkup.new(:indent=>2)
    xml.patent { |p| p.http_status_code(http_status_code); p.application_number(application_number); p.publication_number (publication_number); p.applicant_name(applicant_name); p.applicant_address(applicant_address); p.filing_date(filing_date); p.status(status); p.grant_date(grant_date); p.application_title(application_title); p.last_renewal_date(last_renewal_date); p.next_renewal_date(next_renewal_date); p.last_renewal_year(last_renewal_year); p.error_message(error_message) }

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
    
    mandrill_response_xml = Nokogiri::HTML(open('https://renewalsdesk.herokuapp.com/mandrill/'+params[:template]+'/'+email_to_url+'/'+fullname_to_url+'/'+content1_to_url+'/post'))


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
    
    logger.info response + "\n"

    response.body + "<code>" + response.code.to_s + "</code>"
    

    
end #ends mandrill2

##################################   GO CARDLESS   ##################################

# Initialising GoCardless client

#GoCardless.environment = :sandbox
#GoCardless.account_details = {
#    :app_id => '92JE8HYRG8NPC1ZJXMSBQ59BD2S0D0R6TGXSD5ZM971AFWMJZ1C7DSAPHXN1PABQ',
#    :app_secret => 'AYTVNMFAV89Y8QWJT7CQGA4Q62WT7TC7G9QMGXVTAS34WRKMY48JM82HHP183XJC',
#    :token => 'AYSHQRK99Y40G33QA2A1BVEY7ET90FK4675R8GGZ3B794SEXNWKSK2VMWFK24ZST',
#    :merchant_id => '0HECHG47YP',
#}

GoCardless.environment = :production
GoCardless.account_details = {
    :app_id => 'APZYABQHND1ZMN1Q9H7K38RAXNG4ATEC1CVX9XG5Z3YQRMBJXMX3ZDGHQY7KKDJV',
    :app_secret => 'ZFKNF2X9EVKXDEN910FGX99XFAH7M3WVH69XC7FA6GBRJT7X7REYXCG817KGAHZY',
    :token => 'ER8R7VXZPC0H7RGSX69ETY3MTDM1YCZAD9X4T97J5D71KE6A7093DMP0P6TF1BN9',
    :merchant_id => '0HECHG47YP',
}


### Set up pre-auth ###

get '/gc/preauth/:max_amount/:first_name/:last_name/:email/:company/:add1/:add2/:town/:postcode/:country/:state' do #preauth do1
    
    if params[:country] = "United Kingdom"
        country_code = "GB"
    else
        country_code = ""
    end
    
    url_params = {
        :max_amount => params[:max_amount], #required
        :interval_length => 1, #required
        :interval_unit => "day", #required
        :name => "Authorised Automatic Renewals",
        :redirect_uri => "https://renewalsdesk.herokuapp.com/gc/confirm/preauth",
        :state => params[:state],
        :user => {
            :first_name       => params[:first_name],
            :last_name        => params[:last_name],
            :email            => params[:email],
            :company_name     => params[:company],
            :billing_address1 => params[:add1],
            :billing_address2 => params[:add2],
            :billing_town     => params[:town],
            :billing_postcode => params[:postcode],
            :country_code     => country_code
            
        }
    }
    
    url = GoCardless.new_pre_authorization_url(url_params)
    redirect url
    logger.info url + "\n"
end #ends preauth do1

get '/gc/confirm/preauth' do #do2
    begin GoCardless.confirm_resource(params) #begin1
        "New authorisation created! Redirecting back to RenewalsDesk..."
        url = "https://service.renewalsdesk.com/#View:Pre_Authorisation_Success?PreID="+params[:state]+"&AuthID="+params[:resource_id]
        redirect url
        rescue GoCardless::ApiError => e
        @error = e
        "Could not confirm new subscription. Details: #{e}. Redirecting back to RenewalsDesk..."
        url = "https://service.renewalsdesk.com/#View:Pre_Authorisation_Failure?PreID="+params[:state]
        redirect url
    end #ends begin1
end #ends do2



### Set up one-off bill ###

get '/gc/oneoffbill/:amount/:first_name/:last_name/:email/:company/:add1/:add2/:town/:postcode/:country/:state/:orderID' do #oneoffbill do1
    #state is zoho payment ID
    
    if params[:country] = "United Kingdom"
        country_code = "GB"
        else
        country_code = ""
    end
    
    url_params = {
        :amount => params[:amount], #required
        :name => "Order "+ params[:orderID],
        :redirect_uri => "https://renewalsdesk.herokuapp.com/gc/confirm/oneoffbill",
        :state => params[:state],
        :user => {
            :first_name       => params[:first_name],
            :last_name        => params[:last_name],
            :email            => params[:email],
            :company_name     => params[:company],
            :billing_address1 => params[:add1],
            :billing_address2 => params[:add2],
            :billing_town     => params[:town],
            :billing_postcode => params[:postcode],
            :country_code     => country_code
            
        }
    }
    
    url = GoCardless.new_bill_url(url_params)
    redirect url
    logger.info url + "\n"
end #ends oneoffbill do1

get '/gc/confirm/oneoffbill' do #do2
    begin GoCardless.confirm_resource(params) #begin1
        "New authorisation created! Redirecting back to RenewalsDesk..."
        url = "https://service.renewalsdesk.com/#View:Payment_DD_Success?PayID="+params[:state]+"&GCID="+params[:resource_id]
        redirect url
        rescue GoCardless::ApiError => e
        @error = e
        "Could not confirm new subscription. Details: #{e}. Redirecting back to RenewalsDesk..."
        url = "https://service.renewalsdesk.com/#View:Payment_DD_Failure?PayID="+params[:state]
        redirect url
    end #ends begin1
end #ends do2



### Set up pre-auth bill ###

get '/gc/preauthbill/:amount/:first_name/:last_name/:email/:company/:add1/:add2/:town/:postcode/:country/:state/:orderID/:preauthID' do #preauthbill do1
    #state is zoho payment ID
    
    if params[:country] = "United Kingdom"
        country_code = "GB"
        else
        country_code = ""
    end
    
    url_params = {
        :amount => params[:amount], #required
        :pre_authorization_id => params[:preauthID],
        :name => "Order "+ params[:orderID],
        :redirect_uri => "https://renewalsdesk.herokuapp.com/gc/confirm/preauthbill",
        :state => params[:state],
        :user => {
            :first_name       => params[:first_name],
            :last_name        => params[:last_name],
            :email            => params[:email],
            :company_name     => params[:company],
            :billing_address1 => params[:add1],
            :billing_address2 => params[:add2],
            :billing_town     => params[:town],
            :billing_postcode => params[:postcode],
            :country_code     => country_code
            
        }
    }
    
    url = GoCardless.new_bill_url(url_params)
    redirect url
    logger.info url + "\n"
end #ends preauthbill do1

get '/gc/confirm/preauthbill' do #do2
    begin GoCardless.confirm_resource(params) #begin1
        "New authorisation created! Redirecting back to RenewalsDesk..."
        url = "https://service.renewalsdesk.com/#View:Payment_DD_Success?PayID="+params[:state]+"&GCID="+params[:resource_id]
        redirect url
        rescue GoCardless::ApiError => e
        @error = e
        "Could not confirm new subscription. Details: #{e}. Redirecting back to RenewalsDesk..."
        url = "https://service.renewalsdesk.com/#View:Payment_DD_Failure?PayID="+params[:state]
        redirect url
    end #ends begin1
end #ends do2
