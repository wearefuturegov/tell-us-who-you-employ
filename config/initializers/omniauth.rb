require "outpost"
require "outpost_admin"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :outpost, ENV["OAUTH_CLIENT_ID"], ENV["OAUTH_SECRET"]
  provider :outpost_admin, ENV["OAUTH_ADMIN_CLIENT_ID"], ENV["OAUTH_ADMIN_SECRET"], scope: "public admin"
end
