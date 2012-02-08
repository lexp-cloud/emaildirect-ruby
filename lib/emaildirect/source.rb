require 'emaildirect'
require 'json'

module EmailDirect
  # Represents a source and associated functionality
  class Source
    class << self
      def all
        response = EmailDirect.get '/Sources'
        Hashie::Mash.new(response)
      end

      def create(name, options = {})
        options.merge! :Name => name
        response = EmailDirect.post '/Sources', :body => options.to_json
        Hashie::Mash.new(response)
      end
    end

    attr_reader :source_id

    def initialize(source_id)
      @source_id = source_id
    end

    def details
      response = get
      Hashie::Mash.new(response)
    end

    def members(options = {})
      response = get 'Members', options
      Hashie::Mash.new(response)
    end

    def update(name, options)
      options.merge! :Name => name
      response = EmailDirect.put uri_for, :body => options.to_json
      Hashie::Mash.new(response)
    end

    def delete
      response = EmailDirect.delete uri_for, {}
      Hashie::Mash.new(response)
    end

    def add_emails(email_addresses)
      options = { :EmailAddresses => Array(email_addresses) }
      response = EmailDirect.post uri_for('AddEmails'), :body => options.to_json
      Hashie::Mash.new(response)
    end

    private

    def get(action = nil, options = {})
      EmailDirect.get uri_for(action), :query => options
    end

    def uri_for(action = nil)
      action = "/#{action}" if action
      "/Sources/#{source_id}#{action}"
    end
  end
end

