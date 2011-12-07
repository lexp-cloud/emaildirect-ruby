require 'emaildirect'
require 'mail'

module EmailDirect
  # Implements a Mailer class that can be used by Mail to send using the relay functionality
  class Mailer
    def initialize(values = {})
      self.settings = { :category_id          => nil,
                        :options              => {},
                        :logger               => defined?(Rails) && Rails.logger,
                        :log_level            => :debug
                      }.merge!(values)
      raise ArgumentError, 'Category ID is required' unless settings[:category_id]
    end

    attr_accessor :settings

    def new(*args)
      self
    end

    def deliver!(mail)
      destinations ||= mail.destinations if mail.respond_to?(:destinations) && mail.destinations
      Mail::Message
      if destinations.blank?
        raise ArgumentError.new('At least one recipient (To, Cc or Bcc) is required to send a message')
      end

      options = request_data mail

      # Can only send to a max of 50 addresses at a time
      destinations.each_slice(50).each do |destination_slice|
        options[:Recipients] = []
        destination_slice.each do |destination|
          options[:Recipients] <<  { :ToEmail => destination }
        end
        response = RelaySend::Email.new(settings[:category_id]).send(options)
        settings[:logger].send(settings[:log_level], "EmailDirect: #{response.inspect}") if settings[:logger]
      end
    end

    private

    def request_data(mail)
      options = settings[:options].dup
      options[:Subject] = mail.subject
      options[:Text] = mail.multipart? ? mail.text_part.body.to_s : mail.body.to_s
      options[:HTML] = mail.multipart? ? mail.html_part.body.to_s : mail.body.to_s
      # Set the envelope from to be either the return-path, the sender or the first from address
      envelope_from = mail.return_path || mail.sender || mail.from_addrs.first
      unless envelope_from.blank?
        options[:FromEmail] = envelope_from
        options[:FromName] = mail[:from].display_names.first if mail[:from].display_names.present?
      end
      options
    end
  end
end
