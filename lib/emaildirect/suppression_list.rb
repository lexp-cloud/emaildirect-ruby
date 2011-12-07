require 'emaildirect'
require 'json'

module EmailDirect
  # Represents a list and associated functionality
  class SuppressionList
    class << self
      def all
        response = EmailDirect.get '/SuppressionLists'
        Hashie::Mash.new(response)
      end

      def create(name)
        response = EmailDirect.post '/SuppressionLists', :body => name.to_json
        Hashie::Mash.new(response)
      end
    end

    attr_reader :suppression_list_id

    def initialize(suppression_list_id)
      @suppression_list_id = suppression_list_id
    end

    def details
      response = get
      Hashie::Mash.new(response)
    end

    def emails(options = {})
      response = get 'Emails', :query => options
      Hashie::Mash.new(response)
    end

    def domains(options = {})
      response = get 'Domains', :query => options
      Hashie::Mash.new(response)
    end

    def update(name)
      response = EmailDirect.put uri_for, :body => name.to_json
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

    def add_domains(domain_addresses)
      options = { :DomainNames => domain_addresses.to_a }
      response = post 'AddDomains', :body => options.to_json
      Hashie::Mash.new(response)
    end

    def remove_domains(domain_addresses)
      options = { :DomainNames => domain_addresses.to_a }
      response = post 'RemoveDomains', :body => options.to_json
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
      "/SuppressionLists/#{suppression_list_id}#{action}"
    end
  end
end
