require 'emaildirect'
require 'json'

module EmailDirect
  # Represents a image file and associated functionality
  class ImageFile
    class << self
      def create_from_url(url, options = {})
        options.merge! :URL => url
        response = EmailDirect.post uri, :body => options.to_json
        Hashie::Mash.new(response)
      end

      def create_from_file(file_name, local_path, options = {})
        options.merge! :FileName => file_name
        EmailDirect.post '/ImageUpload', :query => options, :body => File.read(local_path)
      end

      def uri
        '/ImageLibrary'
      end
    end

    attr_reader :file_path

    def initialize(file_path)
      @file_path = file_path
    end

    def details
      response = EmailDirect.get self.class.uri, query
      Hashie::Mash.new(response)
    end

    def delete
      EmailDirect.delete self.class.uri, query
    end

    private

    def query
      { :query => { :File => file_path } }
    end
  end
end

