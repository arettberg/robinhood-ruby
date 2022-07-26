# frozen_string_literal: true

@robinhood = Robinhood::REST::Client.new(username: ENV.fetch("robinhood_username", nil), password: ENV.fetch("robinhood_password", nil))
