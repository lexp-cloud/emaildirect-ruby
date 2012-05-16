require 'emaildirect'
require 'json'

module EmailDirect
  # Represents an order and associated functionality
  class Order
    class << self
      def all(options = {})
        response = EmailDirect.get '/Orders', :query => options
        Hashie::Mash.new(response)
      end

      def create(email, options = {})
        options.merge! :EmailAddress => email
        response = EmailDirect.post '/Orders', :body => options.to_json
        Hashie::Mash.new(response)
      end
      
      def import(orders)
        options = { :Orders => Array(orders) }
        response = EmailDirect.post uri_for('Import'), :body => options.to_json
        Hashie::Mash.new(response)
      end
    end

    attr_reader :order_number

    def initialize(order_number)
      @order_number = order_number
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
      "/Orders/#{order_number}#{action}"
    end
  end
end
