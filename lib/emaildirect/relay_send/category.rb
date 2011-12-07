require 'emaildirect'
require 'json'

module EmailDirect
  # Represents a relay send category and associated functionality
  class RelaySend::Category
    class << self
      def all
        response = EmailDirect.get '/RelaySends'
        Hashie::Mash.new(response)
      end

      def create(category_name)
        response = EmailDirect.post '/RelaySends', :body => category_name.to_json
        Hashie::Mash.new(response)
      end
    end

    attr_reader :category_id

    def initialize(category_id)
      @category_id = category_id
    end

    def details
      response = get
      Hashie::Mash.new(response)
    end

    def update(category_name)
      response = EmailDirect.put uri_for, :body => category_name.to_json
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
      "/RelaySends/#{category_id}#{action}"
    end
  end
end
