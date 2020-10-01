require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Outpost < OmniAuth::Strategies::OAuth2
      option :name, 'outpost'
      option :client_options, {
        site:          "#{ENV["OAUTH_SERVER"]}",
        authorize_url: "#{ENV["OAUTH_SERVER"]}/oauth/authorize"
      }

      uid {
        raw_info['id']
      }

      info do
        {
          email: raw_info['email'],
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        access_token.get('/api/v1/me').parsed
      end
    end
  end
end