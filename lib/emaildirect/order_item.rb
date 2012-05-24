require 'emaildirect'
require 'json'

module EmailDirect
  # Represents an OrderItem and associated functionality
  class OrderItem
    class << self
      def all(options = {})
        response = EmailDirect.get '/Orders/Items', :query => options
        Hashie::Mash.new(response)
      end

      def create(email, options = {})
        options.merge! :EmailAddress => email
        response = EmailDirect.post '/Orders', :body => options.to_json
        Hashie::Mash.new(response)
      end
      
      def import(orders)
        options = { :Orders => Array(orders) }
        response = EmailDirect.post '/Orders/Import', :body => options.to_json
        Hashie::Mash.new(response)
      end
    end

    attr_reader :item_id

    def initialize(item_id)
      @item_id = item_id
    end

    def details
      response = get
      Hashie::Mash.new(response)
    end

    def update(email, options)
      options.merge! :EmailAddress => email
      response = EmailDirect.put uri_for, :body => options.to_json
      Hashie::Mash.new(response)
    end

    def delete
      response = EmailDirect.delete uri_for, {}
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
      "/Orders/Items/#{item_id}#{action}"
    end
  end
end
