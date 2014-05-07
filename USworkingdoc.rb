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
require 'mechanize' #for submitting forms

set :server, 'webrick'


configure :production do
    require 'newrelic_rpm'
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



#######################################   US   #######################################



if params[:country] = "us" #USif1
    
    
    agent =     Mechanize.new
        agent.user_agent = 'User'
        agent.user_agent_alias = 'Windows IE 9'
        #agent.open_timeout = 3
        #agent.read_timeout = 4
        #agent.keep_alive = false
        #agent.max_history = 0 # reduce memory if you make lots of requests
        
    
    begin
    
        page = agent.get 'https://ramps.uspto.gov/eram/patentMaintFees.do'
        form = page.form_with(:name => 'mfInputForm')

            form['applicationNum'] = params[:lookuptype]
            form['patentNum'] = params[:number]
            form['maintFeeAction']= 'Retrieve+Fees+to+Pay'
            
            puts form['applicationNum']
            puts form['patentNum']
            puts form['signature']
            puts form['sessionId']
            puts form['maintFeeYear']
            puts form ['maintFeeAction']
            
            button = form.button_with(:name => 'maintFeeAction')
           
            result_page = form.submit(button)
            
            if result_page.nil?
                puts "No Output"
                else
                puts result_page.body
                end
            
            

    rescue Mechanize::ResponseCodeError
            puts "ResponseCodeError - Code: #{$!}"
    end



    


    
    
    #Nokogiri::HTML(patent_page)
    
    
    # if  patent_page.xpath("//td[contains(text(), 'Application Number:')]")[0] != nil
    #     application_number = patent_page.xpath("//td[contains(text(), 'Application Number')]/following-sibling::*")[0].content
    #    logger.info "Application Number: " + application_number + "\n"
    #end




# # Build XML
# xml = Builder::XmlMarkup.new(:indent=>2)
#  xml.patent { |p| p.application_number(application_number)}

     
end #ends USif1
end #ends allPOlookup