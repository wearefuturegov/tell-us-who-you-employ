require "outpost"

OmniAuth.config.allowed_request_methods = [:post, :get]

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :outpost, ENV["OAUTH_CLIENT_ID"], ENV["OAUTH_SECRET"]
end
