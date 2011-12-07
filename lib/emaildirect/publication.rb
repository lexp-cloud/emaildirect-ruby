require 'emaildirect'
require 'json'

module EmailDirect
  # Represents a publication and associated functionality
  class Publication
    class << self
      def all(options = {})
        response = EmailDirect.get '/Publications', :query => options
        Hashie::Mash.new(response)
      end

      def create(name, options = {})
        options.merge! :Name => name
        response = EmailDirect.post '/Publications', :body => options.to_json
        Hashie::Mash.new(response)
      end
    end

    attr_reader :publication_id

    def initialize(publication_id)
      @publication_id = publication_id
    end

    def details
      response = get
      Hashie::Mash.new(response)
    end

    def members(options = {})
      response = get 'Members', :query => options
      Hashie::Mash.new(response)
    end

    def removes(options = {})
      response = get 'Removes', :query => options
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
      options = { :EmailAddresses => email_addresses.to_a }
      response = post 'AddEmails', :body => options.to_json
      Hashie::Mash.new(response)
    end

    def remove_emails(email_addresses)
      options = { :EmailAddresses => email_addresses.to_a }
      response = post 'RemoveEmails', :body => options.to_json
      Hashie::Mash.new(response)
    end

    private

    def post(action, options)
      EmailDirect.post uri_for(action), options
    end

    def get(action = nil, options = {})
      EmailDirect.get uri_for(action), options
    end

    def uri_for(action = nil)
      action = "/#{action}" if action
      "/Publications/#{publication_id}#{action}"
    end
  end
end
