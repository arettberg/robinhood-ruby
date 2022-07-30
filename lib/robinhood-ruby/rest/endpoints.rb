# frozen_string_literal: true

module Robinhood
  module REST
    class Endpoints
      API_URL_BASE = "https://api.robinhood.com/"
      CRYPTO_URL_BASE = "https://nummus.robinhood.com/"

      ENDPOINTS = {
        login:                    "#{API_URL_BASE}api-token-auth/",
        investment_profile:       "#{API_URL_BASE}user/investment_profile/",
        accounts:                 "#{API_URL_BASE}accounts/",
        ach_iav_auth:             "#{API_URL_BASE}ach/iav/auth/",
        ach_relationships:        "#{API_URL_BASE}ach/relationships/",
        ach_transfers:            "#{API_URL_BASE}ach/transfers/",
        ach_deposit_schedules:    "#{API_URL_BASE}ach/deposit_schedules/",
        applications:             "#{API_URL_BASE}applications/",
        dividends:                "#{API_URL_BASE}dividends/",
        edocuments:               "#{API_URL_BASE}documents/",
        instruments:              "#{API_URL_BASE}instruments/",
        margin_upgrade:           "#{API_URL_BASE}margin/upgrades/",
        markets:                  "#{API_URL_BASE}markets/",
        notifications:            "#{API_URL_BASE}notifications/",
        notifications_devices:    "#{API_URL_BASE}notifications/devices/",
        orders:                   "#{API_URL_BASE}orders/",
        cancel_order:             "#{API_URL_BASE}orders/",
        password_reset:           "#{API_URL_BASE}password_reset/request/",
        quotes:                   "#{API_URL_BASE}quotes/",
        document_requests:        "#{API_URL_BASE}upload/document_requests/",
        user:                     "#{API_URL_BASE}user/",

        user_additional_info:     "#{API_URL_BASE}user/additional_info/",
        user_basic_info:          "#{API_URL_BASE}user/basic_info/",
        user_employment:          "#{API_URL_BASE}user/employment/",
        user_investment_profile:  "#{API_URL_BASE}user/investment_profile/",

        watchlists:               "#{API_URL_BASE}watchlists/",
        positions:                "#{API_URL_BASE}positions/",
        fundamentals:             "#{API_URL_BASE}fundamentals/",
        sp500_up:                 "#{API_URL_BASE}midlands/movers/sp500/?direction=up",
        sp500_down:               "#{API_URL_BASE}midlands/movers/sp500/?direction=down",
        news:                     "#{API_URL_BASE}midlands/news/",

        # crypto:
        crypto_currency_pairs:    "#{CRYPTO_URL_BASE}currency_pairs/",
      }.freeze

      class << self
        def endpoints
          ENDPOINTS
        end
      end
    end
  end
end
