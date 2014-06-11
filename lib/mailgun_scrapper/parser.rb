module MailgunScrapper

  class Parser
    ATTRIBUTE_FIELDS = {
      :tags => ["tags"],
      :user_id => ["user-variables", "user_id"],
      :secondary_tag => ["user-variables", "secondary_tag"],
      :sender => ["envelope", "sender"],
      :recipient => ["recipient"],
      :message_id => ["message", "headers", "message-id"],
      :subject => ["message", "headers", "subject"],
      :event_type => ["event"],
      :timestamp => ["timestamp"]
    }
    attr_accessor :events
    def initialize(logs = [])
      @logs = logs
      @events = []
      get_events
    end

    def get_events
      @logs.each do |log|
        @events << parse_log(log)
      end
    end

    private
      def parse_log(log)
        object_attributes = {}
        REQUIRED_ATTRIBUTE_FIELDS.each_pair do |attribute_key, attribute_path|
          object_attributes[attribute_key] = get_attribute(log, attribute_path)
        end
        return object_attributes
      end

      def get_attribute(log, attribute)
        if attribute.empty?
          return nil
        else
          attribute_value = log
          attribute.each do |path_var|
            attribute_value = attribute_value[path_var]
            if attribute_value.nil?
              break
            end
          end
          return attribute_value
        end
      end
  end

end