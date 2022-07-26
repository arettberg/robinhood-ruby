# frozen_string_literal: true

module Robinhood
  module REST
    class Client < API
      attr_accessor :username, :password, :mfa_code, :token, :private, :headers

      def initialize(username:, password:, mfa_code: nil)
        @username = username
        @password = password
        @mfa_code = mfa_code

        setup_headers
        configuration
        login
      end

      def inspect # :nodoc:
        "<Robinhood::REST::Client @username=#{username}>"
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

        @private = OpenStruct.new({
          "session":     {},
          "account":     nil,
          "username":    nil,
          "password":    nil,
          "mfa_code":    nil,
          "headers":     nil,
          "auth_token":  nil
        })

        @api = {}
      end

      def setup_headers
        @headers ||= {
          "Accept" => "*/*",
          "Accept-Language" => "en;q=1, fr;q=0.9, de;q=0.8, ja;q=0.7, nl;q=0.6, it;q=0.5",
          "Content-Type" => "application/x-www-form-urlencoded; charset=utf-8",
          "X-Robinhood-API-Version" => "1.431.4",
          "Connection" => "keep-alive",
          "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:103.0) Gecko/20100101 Firefox/103.0",
          # "Accept-Encoding" => "gzip, deflate",
        }
      end

      def login
        @private[:username] = username
        @private[:password] = password
        @private[:mfa_code] = mfa_code

        if @private[:auth_token].nil?
          raw_response = HTTParty.post(
            @api_url + "oauth2/token/",
            body: {
              "client_id" => "c82SH0WZOsabOXGP2sxqcj34FxkvfnWRZBKlBjFS",
              "scope" => "internal",
              "grant_type" => "password",
              "password" => @private[:password],
              "username" => @private[:username],
              "mfa_code" => @private[:mfa_code],
              "expires_in" => 1.day.to_i,
              "device_token" => "5014868a-1c3b-406d-8c55-426897c48887",
            }.as_json,
            headers: @headers
          )
          response = JSON.parse(raw_response.body)

          if response["non_field_errors"]
            puts response["non_field_errors"]
            false
          elsif response["access_token"]
            @private[:auth_token] = response["access_token"]
            @headers[:authorization] = "Bearer " + @private[:auth_token].to_s
            @private[:account] = account["results"][0]["url"]
          end
        end
      end
    end
  end
end
