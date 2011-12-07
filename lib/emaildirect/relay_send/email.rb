require 'emaildirect'
require 'json'

module EmailDirect
  # Represents a relay send custom email
  class RelaySend::Email
    attr_reader :category_id

    def initialize(category_id)
      @category_id = category_id
      raise ArgumentError, 'Category ID is required' unless @category_id
    end

    # Sends a custom message.  See the docs for all the possible options
    # @see https://docs.emaildirect.com/#RelaySendCustomEmail
    def send(options)
      response = EmailDirect.post "/RelaySends/#{category_id}", :body => options.to_json
      Hashie::Mash.new(response)
    end
  end
end
