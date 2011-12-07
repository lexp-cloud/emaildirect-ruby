require 'emaildirect'
require 'json'

module EmailDirect
  # Represents a filter and associated functionality
  class Filter
    class << self
      def all
        response = EmailDirect.get '/Filters'
        Hashie::Mash.new(response)
      end
    end

    attr_reader :filter_id

    def initialize(filter_id)
      @filter_id = filter_id
    end

    def details
      response = get
      Hashie::Mash.new(response)
    end

    def members(options = {})
      response = get 'Members', options
      Hashie::Mash.new(response)
    end

    private

    def get(action = nil, options = {})
      EmailDirect.get uri_for(action), :query => options
    end

    def uri_for(action = nil)
      action = "/#{action}" if action
      "/Filters/#{filter_id}#{action}"
    end
  end
end

