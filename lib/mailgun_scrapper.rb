require "mailgun_scrapper/version"
require_relative "./mailgun_scrapper/query"
require_relative "./mailgun_scrapper/parser"

module MailgunScrapper
  class Scrapper
    def initialize(api_key, api_version = 'v2', api_host = 'api.mailgun.net', attributes)
      @api_key = optionapi_key
      @api_version = api_version
      @api_host = api_host
      @required_attributes
    end

    def scrap(options = {})
      logs = MailgunScrapper::Query.new(options, @api_key, ).logs
      MailgunScrapper::Parser.new(logs).events
    end
  end
end
