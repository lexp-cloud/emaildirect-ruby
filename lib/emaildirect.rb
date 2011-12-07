require 'cgi'
require 'uri'
require 'httparty'
require 'hashie'
Hash.send :include, Hashie::HashExtensions

libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'emaildirect/version'
require 'emaildirect/mailer'
require 'emaildirect/campaign'
require 'emaildirect/creative'
require 'emaildirect/creative_folder'
require 'emaildirect/database'
require 'emaildirect/filter'
require 'emaildirect/image_folder'
require 'emaildirect/image_file'
require 'emaildirect/import'
require 'emaildirect/list'
require 'emaildirect/relay_send'
require 'emaildirect/short_url'
require 'emaildirect/publication'
require 'emaildirect/source'
require 'emaildirect/subscriber'
require 'emaildirect/suppression_list'
require 'emaildirect/workflow'

module EmailDirect
  # Just allows callers to do EmailDirect.api_key "..." rather than EmailDirect::EmailDirect.api_key "..." etc
  class << self
    def api_key(api_key=nil)
      r = EmailDirect.api_key api_key
    end
    
    def base_uri(uri)
      r = EmailDirect.base_uri uri
    end
  end

  # Represents a EmailDirect API error and contains specific data about the error.
  class EmailDirectError < StandardError
    attr_reader :data, :code
    def initialize(data)
      @data = data
      super "The EmailDirect API responded with the following error - #{@data.ErrorCode}: #{@data.Message}"
    end
  end

  class ClientError < StandardError; end
  class ServerError < StandardError; end
  class BadRequest < EmailDirectError; end
  class Unauthorized < StandardError; end
  class NotFound < ClientError; end
  class Unavailable < StandardError; end

  class EmailDirect
    include HTTParty
    
    @@base_uri = "https://rest.emaildirect.com/v1/"
    @@api_key = ""
    headers({ 
      'User-Agent' => "emaildirect-rest-#{VERSION}",
      'Content-Type' => 'application/json; charset=utf-8',
      'Accept-Encoding' => 'gzip, deflate' })
    base_uri @@base_uri
    basic_auth 'x', @@api_key

    # Sets the API key which will be used to make calls to the EmailDirect API.
    def self.api_key(api_key=nil)
      return @@api_key unless api_key
      @@api_key = api_key
      basic_auth 'x', @@api_key
    end

    # This call returns an object reflecting the current permissions allowed for the provided API Key
    def ping
      response = EmailDirect.get('/Ping')
      Hashie::Mash.new(response)
    end

    def self.get(*args); handle_response super end
    def self.post(*args); handle_response super end
    def self.put(*args); handle_response super end
    def self.delete(*args); handle_response super end

    def self.handle_response(response) # :nodoc:
      puts response.inspect
      case response.code
      when 400
        raise BadRequest.new(Hashie::Mash.new response)
      when 401
        raise Unauthorized.new
      when 404
        raise NotFound.new
      when 400...500
        raise ClientError.new response.parsed_response
      when 500...600
        raise ServerError.new
      else
        response
      end
    end
  end
end
