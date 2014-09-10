# you need to set this according to your situation/needs
SERVICE_ACCOUNT_EMAIL_ADDRESS = '669298858324-i41pdhb3eus0da7q5kj3i0mdmdgvpru9@developer.gserviceaccount.com' # looks like 12345@developer.gserviceaccount.com
PATH_TO_KEY_FILE              = '../../key/6809c23be00c6e9cb47546cb1242d231c0c2ba02-privatekey.p12' # the path to the downloaded .p12 key file
PROFILE                       = '52955605' # your GA profile id, looks like 'ga:12345'

puts " "
puts "-----------------------------------------------"
puts SERVICE_ACCOUNT_EMAIL_ADDRESS
puts PATH_TO_KEY_FILE
puts PROFILE
puts "-----------------------------------------------"
puts " "

require 'google/api_client'

# set up a client instance
client  = Google::APIClient.new

client.authorization = Signet::OAuth2::Client.new(
  :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
  :audience             => 'https://accounts.google.com/o/oauth2/token',
  :scope                => 'https://www.googleapis.com/auth/analytics.readonly',
  :issuer               => SERVICE_ACCOUNT_EMAIL_ADDRESS,
  :signing_key          => Google::APIClient::PKCS12.load_key(PATH_TO_KEY_FILE, 'notasecret')
).tap { |auth| auth.fetch_access_token! }

api_method = client.discovered_api('analytics','v3').data.ga.get


# make queries
result = client.execute(:api_method => api_method, :parameters => {
  'ids'        => PROFILE,
  'start-date' => Date.new(2000,1,1).to_s,
  'end-date'   => Date.today.to_s,
  'dimensions' => 'ga:pagePath',
  'metrics'    => 'ga:pageviews',
  'filters'    => 'ga:pagePath==/url/to/user'
})

puts result.data.rows.inspect