require 'emaildirect'
require 'json'

module EmailDirect
  # Represents a creative and associated functionality
  class Creative
    class << self
      def all(options = {})
        response = EmailDirect.get '/Creatives', :query => options
        Hashie::Mash.new(response)
      end

      def create(name, options = {})
        options.merge! :Name => name
        response = EmailDirect.post '/Creatives', :body => options.to_json
        Hashie::Mash.new(response)
      end
    end

    attr_reader :creative_id

    def initialize(creative_id)
      @creative_id = creative_id
    end

    def details
      response = get
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

    private

    def get(action = nil)
      EmailDirect.get uri_for(action)
    end

    def uri_for(action = nil)
      action = "/#{action}" if action
      "/Creatives/#{creative_id}#{action}"
    end
  end
end

