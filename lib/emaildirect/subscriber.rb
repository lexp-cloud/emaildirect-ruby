require 'emaildirect'
require 'json'

module EmailDirect
  # Represents a subscriber and associated functionality
  class Subscriber
    class << self
      def active(options = {})
        response = EmailDirect.get '/Subscribers', :query => options
        Hashie::Mash.new(response)
      end

      def removes(options = {})
        response = EmailDirect.get '/Subscribers/Removes', :query => options
        Hashie::Mash.new(response)
      end

      def bounces(options = {})
        response = EmailDirect.get '/Subscribers/Bounces', :query => options
        Hashie::Mash.new(response)
      end

      def complaints(options = {})
        response = EmailDirect.get '/Subscribers/Complaints', :query => options
        Hashie::Mash.new(response)
      end

      def create(email, options = {})
        options.merge! :EmailAddress => email
        self.convert_custom_fields options
        response = EmailDirect.post '/Subscribers', :body => options.to_json
        Hashie::Mash.new(response)
      end

      protected

      def convert_custom_fields(options)
        if options.has_key?(:CustomFields) && options[:CustomFields].is_a?(Hash)
          options[:CustomFields] = options[:CustomFields].map { |k, v| { :FieldName => k, :Value => v } }
        end
      end
    end

    attr_reader :email

    def initialize(email)
      @email = email
    end

    def details
      response = get
      Hashie::Mash.new(response)
    end

    def properties
      response = get 'Properties'
      Hashie::Mash.new(response)
    end

    def history
      response = get 'History'
      Hashie::Mash.new(response)
    end

    def update(options)
      options.merge! :EmailAddress => email
      self.class.convert_custom_fields options
      response = EmailDirect.put uri_for, :body => options.to_json
      Hashie::Mash.new(response)
    end

    def update_custom_field(attribute, value)
      self.class.create email, :CustomFields => [ { :FieldName => attribute, :Value => value } ]
    end

    def update_custom_fields(attributes)
      self.class.create email, :CustomFields => attributes
    end

    def delete
      response = EmailDirect.delete uri_for, {}
      Hashie::Mash.new(response)
    end

    def remove
      options = { :EmailAddress => email }
      response = EmailDirect.post '/Subscribers/Remove', :body => options.to_json
      Hashie::Mash.new(response)
    end

    def change_email(new_email)
      options = { :EmailAddress => new_email }
      response = EmailDirect.post uri_for('ChangeEmail'), :body => options.to_json
      Hashie::Mash.new(response)
    end

    private

    def get(action = nil)
      EmailDirect.get uri_for(action)
    end

    def uri_for(action = nil)
      action = "/#{action}" if action
      "/Subscribers/#{email}#{action}"
    end
  end
end
