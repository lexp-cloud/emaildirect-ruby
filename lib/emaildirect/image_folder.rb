require 'emaildirect'
require 'json'

module EmailDirect
  # Represents a image folder and associated functionality
  class ImageFolder
    class << self
      def all(options = {})
        response = EmailDirect.get uri, :query => options
        Hashie::Mash.new(response)
      end

      def create(name, folder_path = nil)
        options = { :body => name.to_json }
        options[:query] = { :Folder => folder_path } if folder_path
        response = EmailDirect.post uri, options
        Hashie::Mash.new(response)
      end

      def uri
        '/ImageLibrary/Folders'
      end
    end

    attr_reader :folder_path

    def initialize(folder_path)
      @folder_path = folder_path
    end

    def details
      response = EmailDirect.get self.class.uri, query
      Hashie::Mash.new(response)
    end

    def files
      response = EmailDirect.get '/ImageLibrary/Files', query
      Hashie::Mash.new(response)
    end

    def delete
      response = EmailDirect.delete self.class.uri, query
      Hashie::Mash.new(response)
    end

    private

    def query
      { :query => { :Folder => folder_path } }
    end
  end
end

