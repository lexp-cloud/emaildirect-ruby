require 'emaildirect'
require 'json'

module EmailDirect
  # Represents an import and associated functionality
  class Import
    class << self
      def add(subscribers)
        options = { :Subscribers => Array(subscribers) }
        response = EmailDirect.post uri_for('Subscribers'), :body => options.to_json
        Hashie::Mash.new(response)
      end

      def update(subscribers)
        options = { :Subscribers => Array(subscribers) }
        response = EmailDirect.put uri_for('Subscribers'), :body => options.to_json
        Hashie::Mash.new(response)
      end

      def add_or_update(subscribers)
        options = { :Subscribers => Array(subscribers) }
        response = EmailDirect.post uri_for('AddOrUpdate'), :body => options.to_json
        Hashie::Mash.new(response)
      end

      def remove(email_addresses)
        options = { :EmailAddresses => Array(email_addresses) }
        response = EmailDirect.post uri_for('Remove'), :body => options.to_json
        Hashie::Mash.new(response)
      end

      def delete(email_addresses)
        options = { :EmailAddresses => Array(email_addresses) }
        response = EmailDirect.post uri_for('Delete'), :body => options.to_json
        Hashie::Mash.new(response)
      end

      def uri_for(action)
        "/Import/#{action}"
      end
    end
  end
end
