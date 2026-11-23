
require "httparty"

module Billetto
  class Client
    include HTTParty

    BASE_URL = "https://billetto.dk/api/v3".freeze

    def initialize
      @headers = {
        "Api-Keypair" => Rails.application.credentials.dig(
          :billetto, :api_keypair
        ),
        "Accept" => "application/json"
      }
    end

    def fetch_events(limit: 100)
      response = self.class.get(
        "#{BASE_URL}/public/events",
        headers: @headers,
        query: { limit: limit },
        timeout: 15
      )

      unless response.success?
        raise "Billetto API request failed: HTTP #{response.code}"
      end

      response.parsed_response
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      raise "Billetto API timeout: #{e.message}"
    rescue HTTParty::Error, JSON::ParserError => e
      raise "Billetto API error: #{e.message}"
    end
  end
end
