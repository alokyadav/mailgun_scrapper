require 'time'
require 'rest-client'
require 'json'

module MailgunScrapper
  class Query
    NUM_OF_RETRY = 3
    HOST_BASE_URI = "api.mailgun.net"
    RETRY_ALLOWED_RESPONSES = [402, 500, 502, 503, 504]
    API_KEY = "key-0sd0tvg7emzfhdr657yj60d42xr7utu0"
    DOMAIN = "mg.dummy.com"
    INITIAL_URI_PATH = "/v2/#{DOMAIN}/events"
    DEFAULT_BEGIN_TIME = (Time.now - 5 * 24 * 60 * 60).rfc2822
    DEFAULT_END_TIME = Time.now.rfc2822

    attr_accessor :logs
    def initialize(options = {})
      @params = build_params(options)
      @logs = []
      get_logs
    end

    def get_logs
      unless @params.empty?
        log_hash = get_log_page(log_page_uri(INITIAL_URI_PATH), :params => @params)
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
        "https://api:#{API_KEY}@#{HOST_BASE_URI}#{path}"
      end

      def build_params(options = {})
        query_params = {}
        tags = options[:tags] || []
        events = options[:event] || []
        unless tags.empty?
          query_params[:tags] = tags.join(" OR ")
        end
        unless events.empty?
          query_params[:event] = events.join(" OR ")
        end
        query_params[:begin] = options[:begin] || DEFAULT_BEGIN_TIME
        query_params[:end] = options[:end]|| DEFAULT_END_TIME
        query_params[:pretty] = 'yes'
        query_params
      end

  end

end