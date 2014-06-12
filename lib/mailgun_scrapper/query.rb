require 'time'
require 'rest-client'
require 'json'

module MailgunScrapper
  class Query
    NUM_OF_RETRY = 3
    RETRY_ALLOWED_RESPONSES = [402, 500, 502, 503, 504]
    # HOST_BASE_URI = "api.mailgun.net"
    # API_KEY = "key-0sd0tvg7emzfhdr657yj60d42xr7utu0"
    # DOMAIN = "mg.dummy.com"
    # INITIAL_URI_PATH = "/v2/#{DOMAIN}/events"

    #Time interval for collecting logs
    #logs for events occurring between DEFAULT_BEGIN_TIME and DEFAULT_END_TIME are collected if there is no specified interval in options
    DEFAULT_BEGIN_TIME = (Time.now.utc - 5 * 24 * 60 * 60).rfc2822
    DEFAULT_END_TIME = Time.now.utc.rfc2822

    attr_accessor :logs
    def initialize(options = {}, api_key, api_version, api_host, domain)
      @initial_uri_path = "/#{api_version}/#{domain}/events"
      @api_key = api_key
      @api_host = api_host
      @logs = []
      populate_logs(build_params(options))
    end

    def populate_logs(params = {})
      unless params.empty?
        log_hash = get_log_page(log_page_uri(@initial_uri_path), :params => params)
        until log_hash["items"].empty?
          @logs.concat(log_hash["items"])
          log_hash = get_log_page(log_page_uri(URI(log_hash["paging"]["next"]).path))
        end
      end
    end

    private

      def get_log_page(log_page_uri, parameters = {})
        trial = 0
        begin
          json_log = RestClient.get log_page_uri, parameters
          return JSON.parse(json_log)
        rescue RestClient::Exception => e
          if RETRY_ALLOWED_RESPONSES.include?(e.response.code) && trial < NUM_OF_RETRY
            trial += 1
            retry
          else
            raise e
          end
        end
      end

      def log_page_uri(path)
        "https://api:#{@api_key}@#{@api_host}#{path}"
      end

      def build_params(options = {})
        query_params = {}
        query_params.merge!(options)
        unless query_params[:tags].nil?
          query_params[:tags] = query_params[:tags].join(" OR ")
        end
        unless query_params[:event].nil?
          query_params[:event] = query_params[:event].join(" OR ")
        end
        query_params
      end

  end

end