module MailgunScrapper

  class Parser
    ATTRIBUTE_FIELDS = {
      :campaings => ["campaings"],
      :client_info => ["client_info"],
      :delivery_status => ["delivery-status"],
      :delivery_status_code => ["delivery-status", "code"],
      :delivery_status_description => ["delivery-status", "description"],
      :delivery_status_message => ["delivery-status", "message"],
      :delivery_status_session_seconds => ["delivery-status", "session-seconds"],
      :envelope => ["envelope"],
      :envelope_sender => ["envelope", "sender"],
      :envelope_sending_ip => ["envelope", "sending-ip"],
      :envelope_targets => ["envelope", "targets"],
      :envelope_transport => ["envelope", "transport"],
      :event => ["event"],
      :flags => ["flags"],
      :flags_is_authenticated => ["flags", "is-authenticated"],
      :flags_is_system_test => ["flags", "is-system-test"],
      :flags_is_test_mode => ["flags", "is-test-mode"],
      :geolocation => ["geolocation"],
      :geolocation_city => ["geolocation", "city"],
      :geolocation_country => ["geolocation", "country"],
      :geolocation_region => ["geolocation", "region"],
      :ip => ["ip"],
      :message => ["message"],
      :message_attachments => ["message", "attachments"],
      :message_headers => ["message", "headers"],
      :message_headers_from => ["message", "headers", "from"],
      :message_headers_message_id => ["message", "headers", "message-id"],
      :message_headers_subject => ["message", "headers", "subject"],
      :message_headers_to => ["message", "headers", "to"],
      :message_recipients => ["message", "recipients"],
      :message_size => ["message", "size"],
      :method => ["method"],
      :recipient => ["recipient"],
      :recipient_domain => ["recipient-domain"],
      :tags => ["tags"],
      :timestamp => ["timestamp"],
      :url => ["url"],
      :user_variables => ["user-variables"]
    }
    attr_accessor :events
    def initialize(log_entries = [], attributes = [])
      @required_attributes = attributes
      @events = populate_events(log_entries)
    end

    private
      def populate_events(log_entries = [])
        events = log_entries.collect{|log_entry| parse_log(log_entry)}
      end

      def parse_log(log_entry)
        object_attributes = {}
        @required_attributes.each do |attribute_key|
          if ATTRIBUTE_FIELDS.has_key?(attribute_key)
            object_attributes[attribute_key] = get_attribute(log_entry, ATTRIBUTE_FIELDS[attribute_key])
          end
        end
        return object_attributes
      end

      def get_attribute(log_entry, attribute_path)
        if attribute_path.empty?
          return nil
        else
          attribute_value = log_entry
          attribute_path.each do |path_var|
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