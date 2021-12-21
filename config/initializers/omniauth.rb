require "outpost"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :outpost, ENV["OAUTH_CLIENT_ID"], ENV["OAUTH_SECRET"]
end
