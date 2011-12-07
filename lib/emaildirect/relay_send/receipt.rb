require 'emaildirect'
require 'json'

module EmailDirect
  # Represents a relay send receipt and associated functionality
  class RelaySend::Receipt
    attr_reader :receipt_id

    def initialize(receipt_id)
      @receipt_id = receipt_id
    end

    def details
      response = get
      Hashie::Mash.new(response)
    end

    def message
      response = get 'Message'
      Hashie::Mash.new(response)
    end

    def clicks
      response = get 'Clicks'
      Hashie::Mash.new(response)
    end

    private

    def get(action = nil)
      EmailDirect.get uri_for(action)
    end

    def uri_for(action)
      action = "/#{action}" if action
      "/RelaySends/Receipt/#{receipt_id}#{action}"
    end
  end
end
