# frozen_string_literal: true

module Robinhood
  module REST
    class Client < API
      LOGIN_EXPIRATION_SECONDS = 86400

      attr_reader :username,
                  :password,
                  :mfa_code,
                  :auth_token,
                  :token,
                  :private,
                  :headers

      def initialize(username: nil, password: nil, mfa_code: nil, auth_token: nil)
        @username = username
        @password = password
        @mfa_code = mfa_code
        @auth_token = auth_token

        raise ArgumentError if auth_token.nil? && (username.nil? || password.nil?)

        setup_headers
        configuration
        @logged_in = login
      end

      def inspect # :nodoc:
        "<Robinhood::REST::Client @username=#{username}>"
      end

      def logged_in?
        @logged_in
      end

      # TODO: For some reason the JWT returned by Robinhood expires in 7 days,
      #       despite being passed a 1 day expiration time. Find out if the JWT
      #       is the source of truth or not.
      def login_expires_at
        @login_expires_at

        # In reference to the above note:
        # payload = JSON.parse(Base64.decode64(auth_token.split(".")[1]))
        # Time.at(payload["exp"])
      end

      ##
      # Delegate account methods from the client. This saves having to call
      # <tt>client.account</tt> every time for resources on the default
      # account.
      def method_missing(method_name, *args, &block)
        if account.respond_to?(method_name)
          account.send(method_name, *args, &block)
        else
          super
        end
      end

      def respond_to?(method_name, include_private=false)
        if account.respond_to?(method_name, include_private)
          true
        else
          super
        end
      end

      def configuration()
        @api_url = "https://api.robinhood.com/"

        @is_init = false

        @private = OpenStruct.new(
          session: {},
          account: nil,
          username: nil,
          password: nil,
          mfa_code: nil,
          headers: nil,
          auth_token: nil,
        )

        @api = {}
      end

      def setup_headers
        @headers ||= {
          "Accept" => "*/*",
          "Accept-Language" => "en;q=1, fr;q=0.9, de;q=0.8, ja;q=0.7, nl;q=0.6, it;q=0.5",
          "Content-Type" => "application/x-www-form-urlencoded; charset=utf-8",
          "X-Robinhood-API-Version" => "1.431.4",
          "Connection" => "keep-alive",
          "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:104.0) Gecko/20100101 Firefox/104.0",
          # "Accept-Encoding" => "gzip, deflate",
        }
      end

      def login
        @private[:username] = username
        @private[:password] = password
        @private[:mfa_code] = mfa_code
        @private[:auth_token] = auth_token

        if @private[:auth_token].nil?
          raw_response = HTTParty.post(
            @api_url + "oauth2/token/",
            body: {
              client_id: "c82SH0WZOsabOXGP2sxqcj34FxkvfnWRZBKlBjFS",
              scope: "internal",
              grant_type: "password",
              password: @private[:password],
              username: @private[:username],
              mfa_code: @private[:mfa_code],
              expires_in: LOGIN_EXPIRATION_SECONDS,
              device_token: "5014868a-1c3b-406d-8c55-426897c48887",
            },
            headers: @headers,
          )
          response = JSON.parse(raw_response.body)

          if response["non_field_errors"]
            puts response["non_field_errors"]
            false
          elsif response["detail"]
            puts response["detail"]
            false
          elsif response["access_token"]
            @auth_token = response["access_token"]
            @private[:auth_token] = auth_token

            @headers[:authorization] = "Bearer #{auth_token}"
            @private[:account] = account["results"][0]["url"]

            # This may be off by a second or so due to net time
            @login_expires_at = Time.current + LOGIN_EXPIRATION_SECONDS

            true
          end
        else
          @headers[:authorization] = "Bearer #{auth_token}"
          @private[:account] = account["results"][0]["url"]

          true
        end
      end
    end
  end
end
