require 'emaildirect'
require 'json'

module EmailDirect
  # Represents a workflow and associated functionality
  class Workflow
    class << self
      def all
        response = EmailDirect.get '/Workflows'
        Hashie::Mash.new(response)
      end
    end

    attr_reader :workflow_id

    def initialize(workflow_id)
      @workflow_id = workflow_id
    end

    def details
      response = get
      Hashie::Mash.new(response)
    end

    def members(options = {})
      response = get 'Members', :query => options
      Hashie::Mash.new(response)
    end

    def stats(options = {})
      response = get 'Stats', :query => options
      Hashie::Mash.new(response)
    end

    def send_nodes
      response = get 'SendNodes'
      Hashie::Mash.new(response)
    end

    def send_node_details(send_node_id)
      response = get "SendNodes/#{send_node_id}"
      Hashie::Mash.new(response)
    end

    def send_node_stats(send_node_id, options = {})
      response = get "SendNodes/#{send_node_id}/Stats", :query => options
      Hashie::Mash.new(response)
    end

    def start
      response = EmailDirect.put '/Workflows/Start', :body => workflow_id.to_json
      Hashie::Mash.new(response)
    end

    def stop
      response = EmailDirect.put '/Workflows/Stop', :body => workflow_id.to_json
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
      "/Workflows/#{workflow_id}#{action}"
    end
  end
end

