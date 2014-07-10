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

configure :production do
    require 'newrelic_rpm'
end

set :server, 'webrick'


get '/' do
end


get '/lookup/:country/:lookuptype/:number' do #allPOlookup
    
    # the variables are params[:country], params[:lookuptype] and params[:number]
    
   

#######################################   UK   #######################################

### not yet looked up license of right ###


    if params[:country] == "uk" #UKif1
        logger.info "UK patent lookup"
        
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
        
    logger.info "Building UK XML"
    # Build XML
    xml = Builder::XmlMarkup.new(:indent=>2)
    xml.patent { |p| p.http_status_code(http_status_code); p.application_number(application_number); p.publication_number(publication_number); p.applicant_name(applicant_name); p.applicant_address(applicant_address); p.filing_date(filing_date); p.status(status); p.grant_date(grant_date); p.application_title(application_title); p.last_renewal_date(last_renewal_date); p.next_renewal_date(next_renewal_date); p.last_renewal_year(last_renewal_year); p.error_message(error_message) }

#end #ends UKif1


#######################################   FRANCE   #######################################


elsif params[:country] == "france" #FRANCEif1
    
    logger.info "France patent lookup"
   
   # Setting up default response values
    http_status_code = ""
    application_number = ""
    publication_number = ""
    filing_date = ""
    lodged_date = ""
    status = ""
    application_title = ""
    applicant = ""
    proprietor = ""
    last_renewal_date = ""
    next_renewal_date = ""
    last_renewal_year = ""
    error_message = ""
    grant_date = ""


    if #FRANCEif2
        params[:lookuptype] == "application"
        

        patent_page_url = "http://regbrvfr.inpi.fr/register/application?lang=en&number=" + params[:number]
        else
        patent_page_url = ""
    end #ends FRANCEif2
    
    # First, check if it's a valid page
    
    http_status_code = Net::HTTP.get_response(URI.parse(patent_page_url)).code
    
    if #FRANCEif3
        http_status_code.match(/20\d/)
        
        patent_page = Nokogiri::HTML(open(patent_page_url))
        
        # Next, check there's a patent found at that address
        if  #FRANCEif4
            patent_page.xpath("//*[@id=\"body\"]/table/tbody/tr/td")[0] != nil
            
            logger.info "Error message returned!\n"
            error_message = "No patent found under that number."
            logger.info "Message: " + error_message + "\n"
            
            else #related to FRANCEif4
            # No error message, continue to look for data
            logger.info "Data returned!\n"
            # Retrieving page data: Checking if a field exists, and if so, picking up the related contents
            if  patent_page.xpath("//td[contains(text(), 'Application No. and date of filing')]")[0] != nil
                application_number = patent_page.xpath("//td[contains(text(), 'Application No. and date of filing')]/following-sibling::*")[0].content.match(/^[^\ ]*/).to_s
                logger.info "Application Number: " + application_number + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'Publication No. and date')]")[0] != nil
                publication_number = patent_page.xpath("//td[contains(text(), 'Publication No. and date')]/following-sibling::*")[0].content.match(/^[^\ ]*/).to_s
                logger.info "Publication Number: " + publication_number + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'Application No. and date of filing')]")[0] != nil
                filing_date = patent_page.xpath("//td[contains(text(), 'Application No. and date of filing')]/following-sibling::*")[0].content.match(/....-..-../).to_s
                logger.info "Filing Date: " + filing_date + "\n"
            end
            if  patent_page.xpath("//font[@size='3']/text()")[0] != nil
                application_title = patent_page.xpath("//font[@size='3']/text()")[0].content.match(/(?<=\s-\s\s).*[^.]/).to_s
                logger.info "Title: " + application_title + "\n"
            end
            if  patent_page.xpath("//td[starts-with(text(), 'Applicant')]")[0] != nil
                applicant = patent_page.xpath("//td[starts-with(text(), 'Applicant')]/following-sibling::td//text()[1]")[0].content
                logger.info "Applicant: " + applicant + "\n"
            end
            if  patent_page.xpath("//td[starts-with(text(), 'Proprietor')]")[0] != nil
                proprietor = patent_page.xpath("//td[starts-with(text(), 'Proprietor')]/following-sibling::td//text()[1]")[0].content
                logger.info "Proprietor: " + proprietor + "\n"
            end

            if  patent_page.xpath("//td[contains(text(), 'Status')]")[0] != nil
                status = patent_page.xpath("//td[contains(text(), 'Status')]/following-sibling::*")[0].content
                logger.info "Status: " + status + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'Last renewal fee')]")[0] != nil
                last_renewal_date = patent_page.xpath("//td[contains(text(), 'Last renewal fee')]/following-sibling::*")[0].content.match(/....-..-../).to_s
                logger.info "Last Renewal Date: " + last_renewal_date + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'Next renewal fee')]")[0] != nil
                next_renewal_date = patent_page.xpath("//td[contains(text(), 'Next renewal fee')]/following-sibling::*")[0].content
                logger.info "Next Renewal Date: " + next_renewal_date + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'N° of the renewal fee')]")[0] != nil
                last_renewal_year = patent_page.xpath("//td[contains(text(), 'N° of the renewal fee')]/following-sibling::*")[0].content.to_i
                logger.info "Last Renewal Year: " + last_renewal_year.to_s + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'Date of grant')]")[0] != nil
                grant_date = patent_page.xpath("//td[contains(text(), 'Date of grant')]/following-sibling::*")[0].content.match(/....-..-../).to_s
                logger.info "Grant Date: " + grant_date + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'Notification date of lapse')]")[0] != nil
                lapse_date = patent_page.xpath("//td[contains(text(), 'Notification date of lapse')]/following-sibling::*")[0].content.match(/....-..-../).to_s
                logger.info "Lapse Date: " + grant_date + "\n"
                status = "Patent lapsed on " + lapse_date
                logger.info "Status: " + status + "\n"
            end
            
            
        end #ends FRANCEif4
        
    end #ends FRANCEif3
    
    logger.info "Building France XML"
    # Build XML
    xml = Builder::XmlMarkup.new(:indent=>2)
    xml.patent { |p| p.http_status_code(http_status_code); p.application_number(application_number); p.publication_number(publication_number); p.applicant(applicant); p.proprietor(proprietor); p.filing_date(filing_date); p.status(status); p.grant_date(grant_date); p.application_title(application_title); p.last_renewal_date(last_renewal_date); p.next_renewal_date(next_renewal_date); p.last_renewal_year(last_renewal_year); p.error_message(error_message) }
    
    
    #end #ends FRANCEif1


#######################################   GERMANY   #######################################


elsif params[:country] == "germany" #GERMANYif1
    
    logger.info "Germany patent lookup"
    
    if #GERMANYif2
        params[:lookuptype] == "application"
        
        # Setting up default response values
        http_status_code = ""
        de_application_number = ""
        ep_application_number = ""
        wo_application_number = ""
        ep_publication_number = ""
        wo_publication_number = ""
        de_filing_date = ""
        ep_filing_date = ""
        wo_filing_date = ""
        lodged_date = ""
        status = ""
        title = ""
        applicant = ""
        next_renewal_year = ""
        next_renewal_date = ""
        error_message = ""
        grant_publication_date = ""
        
        
        
        patent_page_url = "https://register.dpma.de/DPMAregister/pat/register?lang=en&AKZ=" + params[:number]
        else
        patent_page_url = ""
    end #ends GERMANYif2
    
    # First, check if it's a valid page
    
    http_status_code = Net::HTTP.get_response(URI.parse(patent_page_url)).code
    
    if #GERMANYif3
        http_status_code.match(/20\d/)
        
        patent_page = Nokogiri::HTML(open(patent_page_url))
        
        # Next, check there's a patent found at that address
        if  #GERMANYif4
            patent_page.xpath("//*[@id=\"index\"]/div[5]/p[1]")[0] == "Errors have occurred:"
            
            logger.info "Error message returned!\n"
            error_message = "No patent found under that number."
            logger.info "Message: " + error_message + "\n"
            
            else #related to GERMANYif4
            # No error message, continue to look for data
            logger.info "Data returned!\n"
            
            # Retrieving page data: Checking if a field exists, and if so, picking up the related contents
            if  patent_page.xpath("//td[contains(text(), 'DAKZ')]")[0] != nil
                de_application_number = patent_page.xpath("//td[contains(text(), 'DAKZ')]/following-sibling::*")[0].content
                logger.info "DE Application Number: " + de_application_number + "\n"
                end
            if  patent_page.xpath("//td[contains(text(), 'EAKZ')]")[0] != nil
                ep_application_number = patent_page.xpath("//td[contains(text(), 'EAKZ')]/following-sibling::*")[0].content
                logger.info "EP Application Number: " + ep_application_number + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'WAKZ')]")[0] != nil
                wo_application_number = patent_page.xpath("//td[contains(text(), 'WAKZ')]/following-sibling::*")[0].content
                logger.info "WO Application Number: " + wo_application_number + "\n"
            end
            if  patent_page.xpath("//td[(text() = 'EPN')]")[0] != nil
                ep_publication_number = patent_page.xpath("//td[(text() = 'EPN')]/following-sibling::*")[0].content
                logger.info "EP Publication Number: " + ep_publication_number + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'WPN')]")[0] != nil
                wo_publication_number = patent_page.xpath("//td[contains(text(), 'WPN')]/following-sibling::*")[0].content
                logger.info "WO Publication Number: " + wo_publication_number + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'DAT')]")[0] != nil
                de_filing_date = patent_page.xpath("//td[contains(text(), 'DAT')]/following-sibling::*")[0].content
                logger.info "DE Filing Date: " + de_filing_date + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'EAT')]")[0] != nil
                ep_filing_date = patent_page.xpath("//td[contains(text(), 'EAT')]/following-sibling::*")[0].content
                logger.info "EP Filing Date: " + ep_filing_date + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'WAT')]")[0] != nil
                wo_filing_date = patent_page.xpath("//td[contains(text(), 'WAT')]/following-sibling::*")[0].content
                logger.info "WO Filing Date: " + wo_filing_date + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'TI')]")[0] != nil
                title = patent_page.xpath("//td[contains(text(), 'TI')]/following-sibling::*")[0].content
                logger.info "Title: " + title + "\n"
            end
            if  patent_page.xpath("//td[starts-with(text(), 'INH')]")[0] != nil
                applicant = patent_page.xpath("//td[starts-with(text(), 'INH')]/following-sibling::*")[0].content
                logger.info "Applicant: " + applicant + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'ST')]")[0] != nil
                status = patent_page.xpath("//td[contains(text(), 'ST')]/following-sibling::*")[0].content
                logger.info "Status: " + status + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'FT')]")[0] != nil
                next_renewal_date = patent_page.xpath("//td[contains(text(), 'FT')]/following-sibling::*")[0].content.match(/...\s\d\d,\s\d\d\d\d/).to_s
                logger.info "Next Renewal Date: " + next_renewal_date + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'FT')]")[0] != nil
                next_renewal_year = patent_page.xpath("//td[contains(text(), 'FT')]/following-sibling::*")[0].content.match(/(\d+(?=(th|nd|rd)))/).to_s
                logger.info "Next Renewal Year: " + next_renewal_year + "\n"
            end
            if  patent_page.xpath("//td[contains(text(), 'PET')]")[0] != nil
                grant_publication_date = patent_page.xpath("//td[contains(text(), 'PET')]/following-sibling::*")[0].content
                logger.info "Grant Publication Date: " + grant_publication_date + "\n"
            end
            
        end #ends GERMANYif4
        
    end #ends GERMANYif3
    
    
    logger.info "Building Germany XML"
    # Build XML
    xml = Builder::XmlMarkup.new(:indent=>2)
    xml.patent { |p| p.http_status_code(http_status_code); p.de_application_number(de_application_number); p.ep_application_number(ep_application_number); p.wo_application_number(wo_application_number); p.ep_publication_number(ep_publication_number); p.wo_publication_number(wo_publication_number); p.applicant(applicant); p.de_filing_date(de_filing_date); p.ep_filing_date(ep_filing_date); p.wo_filing_date(wo_filing_date); p.status(status); p.grant_publication_date(grant_publication_date); p.title(title);  p.next_renewal_date(next_renewal_date); p.next_renewal_year(next_renewal_year); p.error_message(error_message) }
    #end #ends GERMANYif1


#######################################   AUSTRALIA   #######################################


elsif params[:country] == "australia" #AUSTRALIAif1

logger.info "Australia patent lookup"

# Setting up default response values
http_status_code = ""
application_number = ""
filing_date = ""
status = ""
application_title = ""
applicant = ""
applicant_address = ""
last_renewal_date = ""
next_renewal_date = ""
next_renewal_year = ""
error_message = ""
priority_date = ""
patent_page_url = ""
disclaimer_page = ""


if #AUSTRALIAif2
    params[:lookuptype] == "application"
    agent = Mechanize.new
    patent_page_url = "http://pericles.ipaustralia.gov.au/ols/auspat/applicationDetails.do?applicationNo=" + params[:number]
    disclaimer_page = agent.get("http://pericles.ipaustralia.gov.au/ols/auspat/")
    
    # Get the form
    form = agent.page.form
    # Get the button you want from the form
    button = form.button_with(:value => "Accept")
    # Submit the form using that button
    agent.submit(form, button)
    logger.info agent.cookies.to_s
    
    patent_page = agent.get(patent_page_url)
    
    else
    patent_page_url = ""
end #ends AUSTRALIAif2

# First, check if it's a valid page

http_status_code = Net::HTTP.get_response(URI.parse(patent_page_url)).code

if #AUSTRALIAif3
    http_status_code.match(/20\d/)
    
    #patent_page = Nokogiri::HTML(open(patent_page_url))
    
    # Next, check there's a patent found at that address
    if  #AUSTRALIAif4
        patent_page.parser.xpath("//*[@id=\"content\"]/div/p[1]/text()")[0] == "There was a problem trying to retrieve this record. Please check the application number and try again."
        
        logger.info "Error message returned!\n"
        error_message = "No patent found under that number."
        logger.info "Message: " + error_message + "\n"
        
        else #related to AUSTRALIAif4
        # No error message, continue to look for data
        logger.info "Data returned!\n"
        # Retrieving page data: Checking if a field exists, and if so, picking up the related contents
        if  patent_page.parser.xpath("//td[contains(text(), 'Australian application number')]") != nil
            application_number = patent_page.parser.xpath("//td[contains(text(), 'Australian application number')]/following-sibling::*[1]")[0].content
            logger.info "Application Number: " + application_number + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Filing date')]")[0] != nil
            filing_date = patent_page.parser.xpath("//td[contains(text(), 'Filing date')]/following-sibling::*[1]")[0].content
            logger.info "Filing Date: " + filing_date + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Invention title')]")[0] != nil
            application_title = patent_page.parser.xpath("//td[contains(text(), 'Invention title')]/following-sibling::*[1]")[0].content
            logger.info "Title: " + application_title + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Applicant')]")[0] != nil
            applicant = patent_page.parser.xpath("//td[contains(text(), 'Applicant')]/following-sibling::*[1]")[0].content
            logger.info "Applicant: " + applicant + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Applicant address')]")[0] != nil
            applicant_address = patent_page.parser.xpath("//td[contains(text(), 'Applicant address')]/following-sibling::*[1]")[0].content.match(/(\w+ )+\w+/).to_s
            logger.info "Applicant address: " + applicant_address + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Application status')]")[0] != nil
            status = patent_page.parser.xpath("//td[contains(text(), 'Application status')]/following-sibling::*[1]")[0].content
            logger.info "Status: " + status + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Date paid')]")[0] != nil
            last_renewal_date = patent_page.parser.xpath("//td[contains(text(), 'Date paid')]/following-sibling::*[1]")[0].content
            logger.info "Last Renewal Date: " + last_renewal_date + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Paid to date')]")[0] != nil
            next_renewal_date = patent_page.parser.xpath("//td[contains(text(), 'Paid to date')]/following-sibling::*[1]")[0].content
            logger.info "Next Renewal Date: " + next_renewal_date + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Next fee due')]")[0] != nil
            next_renewal_year = patent_page.parser.xpath("//td[contains(text(), 'Next fee due')]/following-sibling::*[1]")[0].content.match(/\d+/).to_s
            logger.info "Next Renewal Year: " + next_renewal_year + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Earliest priority date')]")[0] != nil
            priority_date = patent_page.parser.xpath("//td[contains(text(), 'Earliest priority date')]/following-sibling::*[1]")[0].content
            logger.info "Priority Date: " + priority_date + "\n"
        end
        
        
    end #ends AUSTRALIAif4
    
end #ends AUSTRALIAif3

logger.info "Building Australia XML"
# Build XML
xml = Builder::XmlMarkup.new(:indent=>2)
xml.patent { |p| p.http_status_code(http_status_code); p.application_number(application_number); p.applicant(applicant); p.applicant_address(applicant_address); p.filing_date(filing_date); p.status(status); p.application_title(application_title); p.last_renewal_date(last_renewal_date); p.next_renewal_date(next_renewal_date); p.next_renewal_year(next_renewal_year); p.priority_date(priority_date); p.error_message(error_message) }






#######################################   CANADA   #######################################


elsif params[:country] == "canada" #CANADA

logger.info "Canada patent lookup \n"

# Setting up default response values
http_status_code = ""
application_number = ""
world_application_number = ""
world_publication_number = ""
filing_date = ""
status = ""
title = ""
applicant = ""
grant_date = ""
local_agent = ""
last_renewal_date = ""
next_renewal_date = ""
error_message = ""
patent_title_page_url = ""
patent_renewal_page_url = ""

if #CANADA if2
    params[:lookuptype] == "document"
    agent = Mechanize.new
    patent_title_page_url = "http://brevets-patents.ic.gc.ca/opic-cipo/cpd/eng/patent/" + params[:number] + "/summary.html?type=number_search"
    patent_renewal_page_url = "http://brevets-patents.ic.gc.ca/opic-cipo/cpd/eng/patent/" + params[:number] + "/financial_transactions.html?type=number_search"
    
    logger.info patent_title_page_url + "\n"
    logger.info patent_renewal_page_url + "\n"
    
    else
    patent_title_page_url = ""
    patent_title_page_url = ""
end #ends CANADA if2

# First, check if it's a valid page

http_status_code = Net::HTTP.get_response(URI.parse(patent_title_page_url)).code
logger.info "HTTP Status Code: " + http_status_code + "\n"


if #CANADA if3
http_status_code.match(/20\d/)
    
    #patent_title_page = Nokogiri::HTML(open(patent_title_page_url))
    
    patent_title_page = agent.get(patent_title_page_url)
    
    # Next, check there's a patent found at that address
    if  #CANADA if4.1
        patent_title_page.parser.xpath("/html/body/div[1]/div/div[6]/div[2]/h2/text()") == "Patent Not Found"
        
        logger.info "Error message returned!\n"
        error_message = "No title page patent found under that number."
        logger.info "Message: " + error_message + "\n"
        
        else #related to CANADA if4.1
        # No error message, continue to look for data
        logger.info "Title data returned!\n"
        
        # Retrieving page data: Checking if a field exists, and if so, picking up the related contents
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'English Title')]]")[0] != nil
            title = patent_title_page.parser.xpath("//th[a[contains(text(), 'English Title')]]/following-sibling::*")[0].content.match(/(\w+ )+\w+/).to_s
            logger.info "Title: " + title + "\n"
        end
        if  patent_title_page.parser.xpath("//td[a[contains(text(), '(11)')]]") != nil
            application_number = patent_title_page.parser.xpath("//td[a[contains(text(), '(11)')]]/strong/text()")[0].content.match(/CA\s\d+/).to_s
            logger.info "Application Number: " + application_number + "\n"
        end
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'Filed')]]")[0] != nil
            filing_date = patent_title_page.parser.xpath("//th[a[contains(text(), 'Filed')]]/following-sibling::*")[0].content.match(/\d\d\d\d-\d\d-\d\d/).to_s
            logger.info "Filing Date: " + filing_date + "\n"
        end
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'PCT Filing Date')]]")[0] != nil
            filing_date = patent_title_page.parser.xpath("//th[a[contains(text(), 'PCT Filing Date')]]/following-sibling::*")[0].content.match(/\d\d\d\d-\d\d-\d\d/).to_s

            logger.info "Filing Date: " + filing_date + "\n"
        end
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'Applicants')]]")[0] != nil
            applicant = patent_title_page.parser.xpath("//th[a[contains(text(), 'Applicants')]]/following-sibling::*")[0].content.match(/(\w+ )+\w+/).to_s
            logger.info "Applicant: " + applicant + "\n"
        end
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'Issued')]]")[0] != nil
            grant_date = patent_title_page.parser.xpath("//th[a[contains(text(), 'Issued')]]/following-sibling::*")[0].content.match(/\d\d\d\d-\d\d-\d\d/).to_s

            logger.info "Grant Date: " + grant_date + "\n"
        end
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'PCT Filing Number')]]")[0] != nil
            world_application_number = patent_title_page.parser.xpath("//th[a[contains(text(), 'PCT Filing Number')]]/following-sibling::*")[0].content
            logger.info "World Application Number: " + world_application_number + "\n"
        end
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'International Publication Number')]]")[0] != nil
            world_publication_number = patent_title_page.parser.xpath("//th[a[contains(text(), 'International Publication Number')]]/following-sibling::*")[0].content
            logger.info "World Publication Number: " + world_publication_number + "\n"
        end
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'Agent')]]")[0] != nil
            local_agent = patent_title_page.parser.xpath("//th[a[contains(text(), 'Agent')]]/following-sibling::*")[0].content.match(/(\w+ )+\w+/).to_s
            logger.info "Agent: " + local_agent + "\n"
        end

        # Set up status
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'Granted')]]")[0] != nil
            status = "Granted"
            logger.info "Status unless changed later: " + status + "\n"
        end
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'Patent Application')]]")[0] != nil
            status = "Application in Progress"
            logger.info "Status unless changed later: " + status + "\n"
        end
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'Reissued')]]")[0] != nil
            status = "Reissued"
            logger.info "Status unless changed later: " + status + "\n"
        end
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'Dead Application')]]")[0] != nil
            status = "Application Dead"
            logger.info "Status unless changed later: " + status + "\n"
        end
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'Withdrawn Application')]]")[0] != nil
            status = "Application Withdrawn"
            logger.info "Status unless changed later: " + status + "\n"
        end
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'Surrendered')]]")[0] != nil
            status = "Surrendered"
            logger.info "Status unless changed later: " + status + "\n"
        end
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'Lapsed')]]")[0] != nil
            status = "Lapsed"
            logger.info "Status unless changed later: " + status + "\n"
        end
        if  patent_title_page.parser.xpath("//th[a[contains(text(), 'Expired')]]")[0] != nil
            status = "Expired"
            logger.info "Status unless changed later: " + status + "\n"
        end

        # Next open renewal page
        patent_renewal_page = agent.get(patent_renewal_page_url)
        
        if  #CANADA if4.2
            patent_renewal_page.parser.xpath("html/body/div/div/div[6]/div[2]/h2/text()") == "Patent Not Found"
            
            logger.info "Error message returned!\n"
            error_message = "No renewal page for patent found under that number."
            logger.info "Message: " + error_message + "\n"
            
            else #related to CANADA if4.2
            # No error message, continue to look for data
            logger.info "Renewal data returned!\n"

                if  patent_renewal_page.parser.xpath("//td[a[contains(text(), 'Last Payment')]]")[0] != nil
                    last_renewal_date = patent_renewal_page.parser.xpath("//td[a[contains(text(), 'Last Payment')]]/following-sibling::*")[0].content.match(/\d\d\d\d-\d\d-\d\d/).to_s

                    logger.info "Last Renewal Date: " + last_renewal_date + "\n"
                end
                if  patent_renewal_page.parser.xpath("//td[a[contains(text(), 'Next Payment')]]")[0] != nil
                    next_renewal_date = patent_renewal_page.parser.xpath("//td[a[contains(text(), 'Next Payment')]]/following-sibling::*")[0].content.match(/\d\d\d\d-\d\d-\d\d/).to_s

                    logger.info "Next Renewal Date: " + next_renewal_date + "\n"
                end
                
        end #ends CANADA if4.2
        
    end #ends CANADA if4.1
    
end #ends CANADA if3

logger.info "Building Canada XML"
# Build XML
xml = Builder::XmlMarkup.new(:indent=>2)
xml.patent { |p| p.http_status_code(http_status_code); p.application_number(application_number); p.world_application_number(world_application_number); p.world_publication_number(world_publication_number); p.applicant(applicant); p.grant_date(grant_date); p.filing_date(filing_date); p.status(status); p.title(title); p.last_renewal_date(last_renewal_date); p.next_renewal_date(next_renewal_date); p.local_agent(local_agent); p.error_message(error_message) }





#######################################   US   #######################################


elsif params[:country] == "us" #USif1

logger.info "US patent lookup"

# Setting up default response values
http_status_code = ""
application_number = ""
patent_number = ""
filing_date = ""
grant_date = ""
status = ""
title = ""
entity_type = ""
service_address = ""
payment_window_start = ""
surcharge_date = ""
error_message = ""
shopping_homepage = ""
search_page = ""


if #USif2
    # params[:lookuptype] - using as application number
    # params[:number] - using as patent number
    agent = Mechanize.new
    shopping_homepage = agent.get("https://ramps.uspto.gov/eram/")
    search_page = agent.get("https://ramps.uspto.gov/eram/patentMaintFees.do")
    logger.info agent.cookies.to_s
    
    # Get the form
    form = agent.page.form
    # Fill in form
    form.field_with(:name => 'patentNum').value = params[:number]
    form.field_with(:name => 'applicationNum').value = params[:lookuptype]
    # Get the button you want from the form
    button = form.button_with(:value => "Get Bibliographic Data")
    # Submit the form using that button
    patent_page = agent.submit(form, button)
    logger.info agent.cookies.to_s
    logger.info patent_page

    
    else
    patent_page = ""
end #ends USif2

# Next, check patent page is a valid page

http_status_code = patent_page.code

if #USif3
    http_status_code.match(/20\d/)
    
    #patent_page = Nokogiri::HTML(open(patent_page_url))
    
    # Next, check there are no error messages
    if  #USif4
        search_page.parser.css("//span[@class='errMsg']/text()") == "Application Number and Patent Number Mismatch."
        logger.info "Error message returned!\n"
        error_message = search_page.parser.css("//span[@class='errMsg']")[0].content
        logger.info "Unable to retrieve patent. \n"
        
        else #related to USif4
        # No error message, continue to look for data
        logger.info "Data returned!\n"
        # Retrieving page data: Checking if a field exists, and if so, picking up the related contents
        if  patent_page.parser.xpath("//td[contains(text(), 'Application Number')]") != nil
            application_number = patent_page.parser.xpath("/html").to_s
            logger.info "Application Number: " + application_number + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Patent Number')]") != nil
            patent_number = patent_page.parser.xpath("//td[contains(text(), 'Patent Number')]/following-sibling::*")[0].content
            logger.info "Patent Number: " + patent_number + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Filing Date')]") != nil
            filing_date = patent_page.parser.xpath("//tr[td[contains(text(), 'Filing Date')]]").to_s
            logger.info "Filing Date: " + filing_date + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Issue Date')]") != nil
            grant_date = patent_page.parser.xpath("//td[contains(text(), 'Issue Date')]/following-sibling::*")[0].content
            logger.info "Grant Date: " + grant_date + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Title')]") != nil
            title = patent_page.parser.xpath("//td[contains(text(), 'Title')]/following-sibling::*")[0].content
            logger.info "Title: " + title + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Entity')]") != nil
            entity_type = patent_page.parser.xpath("//td[contains(text(), 'Entity')]/following-sibling::*")[0].content.camelize
            logger.info "Entity Type: " + entity_type + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Address for fee purposes')]") != nil
            service_address = patent_page.parser.xpath("//td[contains(text(), 'Address for fee purposes')]/following-sibling::*")[0].content
            logger.info "Service Address: " + service_address + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Application status')]") != nil
            status = patent_page.parser.xpath("//td[contains(text(), 'Application status')]/following-sibling::*")[0].content
            logger.info "Status: " + status + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Window Opens')]") != nil
            payment_window_start = patent_page.parser.xpath("//td[contains(text(), 'Window Opens')]/following-sibling::*")[0].content.match #INCOMPLETE
            logger.info "Payment Window Start: " + payment_window_start + "\n"
        end
        if  patent_page.parser.xpath("//td[contains(text(), 'Surcharge Date')]") != nil
            surcharge_date = patent_page.parser.xpath("//td[contains(text(), 'Surcharge Date')]/following-sibling::*")[0].content
            logger.info "Surcharge Date: " + surcharge_date + "\n"
        end
        
    end #ends USif4
    
end #ends USif3

logger.info "Building US XML"
# Build XML
xml = Builder::XmlMarkup.new(:indent=>2)
xml.patent { |p| p.http_status_code(http_status_code); p.application_number(application_number); p.patent_number(patent_number); p.entity_type(entity_type); p.service_address(service_address); p.filing_date(filing_date); p.grant_date(grant_date); p.status(status); p.title(title); p.payment_window_start(payment_window_start); p.surcharge_date(surcharge_date); p.error_message(error_message) }



####################################   End of all country specific code   ####################################


    else # no known country - do nothing - related to all if and else ifs number 1s

    end #ends all if and else ifs number 1s
    
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
    
    pre_auth = GoCardless::PreAuthorization.find(params[:preauthID])
    pre_auth.create_bill(
                         :name => "Order " + params[:orderID],
                         :amount => params[:amount]
                         )

end #ends preauthbill do1

#get '/gc/confirm/preauthbill' do #do2
#    begin GoCardless.confirm_resource(params) #begin1
#        "New pre-authorised bill created! Redirecting back to RenewalsDesk..."
#        url = "https://service.renewalsdesk.com/#View:Payment_DD_Success?PayID="+params[:state]+"&GCID="+params[:resource_id]
#        redirect url
#        rescue GoCardless::ApiError => e
#        @error = e
#        "Could not confirm new subscription. Details: #{e}. Redirecting back to RenewalsDesk..."
#        url = "https://service.renewalsdesk.com/#View:Payment_DD_Failure?PayID="+params[:state]
#        redirect url
#    end #ends begin1
#end #ends do2




#################################### TOTAL PATENT NUMBER SEARCH ###################################


get '/leadgen/totalpatnumbersearch/:applicant' do #total patent number search
    
    logger.info "Performing total patent number search on Espacenet\n"

    #reset variables
    totalpatentnumber = 0
    
    results_page_url = "http://worldwide.espacenet.com/searchResults?compact=false&ST=advanced&locale=en_EP&DB=EPODOC&PA=" + params[:applicant]

    # First, check if it's a valid page
    http_status_code = Net::HTTP.get_response(URI.parse(results_page_url)).code
    logger.info "Espacenet HTTP Code: " + http_status_code + "\n"


    if http_status_code.match(/20\d/)
    
        results_page = Nokogiri::HTML(open(results_page_url))
        
        # Retrieving page data: Checking if a field exists, and if so, picking up the related contents
        if  results_page.css(".epoBarItem>p>b")[0] != nil
            totalpatentnumber = results_page.css(".epoBarItem>p>b")[0].content
            logger.info "Number of Patents Found: " + totalpatentnumber + "\n"
        end
    end
    
    #Build XML
    xml = Builder::XmlMarkup.new(:indent=>2)
    xml.result { |n| n.http_status_code(http_status_code); n.totalpatentnumber(totalpatentnumber) }

    end #total patent number search

