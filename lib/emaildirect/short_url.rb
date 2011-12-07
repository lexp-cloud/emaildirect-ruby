require 'emaildirect'
require 'json'

module EmailDirect
  # Represents a short url and associated functionality
  class ShortUrl
    class << self
      def all(options = {})
        response = EmailDirect.get uri, :query => options
        Hashie::Mash.new(response)
      end

      def create(url)
        options = { :Url => url }
        response = EmailDirect.post uri, :body => options.to_json
        Hashie::Mash.new(response)
      end

      def uri
        '/ShortUrls'
      end
    end

    attr_reader :short_url

    def initialize(short_url)
      @short_url = short_url
    end

    def details
      response = EmailDirect.get self.class.uri, query
      Hashie::Mash.new(response)
    end

    def update(new_url)
      response = EmailDirect.put self.class.uri, query.merge(:body => new_url.to_json)
      Hashie::Mash.new(response)
    end

    def clicks(options = {})
      options.merge! :url => short_url
      response = EmailDirect.get '/ShortUrls/Clicks', :query => options
      Hashie::Mash.new(response)
    end

    private

    def query
      { :query => { :url => short_url } }
    end
  end
end

