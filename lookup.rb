require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'sinatra'
require 'open-uri'
require 'builder'
require 'gocardless'

##################################   GO CARDLESS   ##################################

# Initialising GoCardless client
GoCardless.environment = :sandbox
GoCardless.account_details = {
    :app_id => '92JE8HYRG8NPC1ZJXMSBQ59BD2S0D0R6TGXSD5ZM971AFWMJZ1C7DSAPHXN1PABQ',
    :app_secret => 'AYTVNMFAV89Y8QWJT7CQGA4Q62WT7TC7G9QMGXVTAS34WRKMY48JM82HHP183XJC',
    :token => 'AYSHQRK99Y40G33QA2A1BVEY7ET90FK4675R8GGZ3B794SEXNWKSK2VMWFK24ZST',
    :merchant_id => '0HECHG47YP',
}

get '/:email/subscribe' do
    
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
end

get '/confirm' do
    begin GoCardless.confirm_resource(params)
        "New subscription created!"
        rescue GoCardless::ApiError => e
        @error = e
        "Could not confirm new subscription. Details: #{e}"
    end
end




### need to deal with situation where no internet connection ###

get '/:country/:lookuptype/:number' do
    # the variables are params[:country], params[:lookuptype] and params[:number]

#######################################   UK   #######################################

    if params[:country] = "uk"

        if params[:lookuptype] = "application"
            patent_page_url = "http://www.ipo.gov.uk/p-ipsum/Case/ApplicationNumber/" + params[:number]
        else
            #params[:type] must equal  - not dealing with any other scenario - input from zoho must be application or publication
            patent_page_url = "http://www.ipo.gov.uk/p-ipsum/Case/PublicationNumber/" + params[:number]
        end

        patent_page = Nokogiri::HTML(open(patent_page_url))

### need to handle 404 error (and others) ###

        #lookup up data on page and saving into
### need to work out which fields patents have or work out way not to have errors thrown up if xpath cannot be found ###


        application_number = patent_page.xpath("//td[contains(text(), 'Application Number')]/following-sibling::*")[0].content
        publication_number = patent_page.xpath("//td[contains(text(), 'Publication Number')]/following-sibling::*")[0].content
        filing_date = patent_page.xpath("//td[contains(text(), 'Filing Date')]/following-sibling::*")[0].content
        application_title = patent_page.xpath("//td[contains(text(), 'Application Title')]/following-sibling::*")[0].content
        applicant = patent_page.xpath("//td[contains(text(), 'Applicant / Proprietor')]/following-sibling::*")[0].content
        status = patent_page.xpath("//td[contains(text(), 'Status')]/following-sibling::*")[0].content

        #possible statuses seen: Granted,

        if status == 'Granted'
            last_renewal_date = patent_page.xpath("//td[contains(text(), 'Last Renewal Date')]/following-sibling::*")[0].content
            last_renewal_date.split(' ')
            next_renewal_date = patent_page.xpath("//td[contains(text(), 'Next Renewal Date')]/following-sibling::*")[0].content
            last_renewal_year = patent_page.xpath("//td[contains(text(), 'Year of Last Renewal')]/following-sibling::*")[0].content.to_i
        else
            last_renewal_date = ""
            next_renewal_date = ""
            last_renewal_year = 0
        end


### not yet looked up license of right ###

        
        xml = Builder::XmlMarkup.new(:indent=>2)
        xml.patent { |p| p.status(status); p.application_title(application_title); p.last_renewal_date(last_renewal_date); p.next_renewal_date(next_renewal_date); p.last_renewal_year(last_renewal_year) }
    end

end