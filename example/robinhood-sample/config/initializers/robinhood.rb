# frozen_string_literal: true

@robinhood = Robinhood::REST::Client.new(ENV['robinhood_username'], ENV['robinhood_password'])