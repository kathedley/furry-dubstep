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
