key =  Rails.env.production? ? ENV['MAILCHIMP_KEY'] : 'test'

Gibbon::API.api_key = key
Gibbon::API.timeout = 15
Gibbon::API.throws_exceptions = false
