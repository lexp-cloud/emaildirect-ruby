require 'emaildirect'
require 'json'

module EmailDirect
  # Represents a creative folder and associated functionality
  class CreativeFolder
    class << self
      def all(options = {})
        response = EmailDirect.get '/Creatives/Folders', :query => options
        Hashie::Mash.new(response)
      end

      def create(name, parent_id = nil)
        uri = '/Creatives/Folders'
        uri << "/#{parent_id}" if parent_id
        response = EmailDirect.post uri, :body => name.to_json
        Hashie::Mash.new(response)
      end
    end

    attr_reader :folder_id

    def initialize(folder_id)
      @folder_id = folder_id
    end

    def details
      response = get
      Hashie::Mash.new(response)
    end

    def templates(options = {})
      response = get 'Templates', options
      Hashie::Mash.new(response)
    end

    def update(name)
      response = EmailDirect.put uri_for, :body => name.to_json
      Hashie::Mash.new(response)
    end

    def delete
      response = EmailDirect.delete uri_for, {}
      Hashie::Mash.new(response)
    end

    private

    def get(action = nil, options = {})
      EmailDirect.get uri_for(action), :query => options
    end

    def uri_for(action = nil)
      action = "/#{action}" if action
      "/Creatives/Folders/#{folder_id}#{action}"
    end
  end
end

