require 'emaildirect'
require 'json'

module EmailDirect
  # Represents a campaign and associated functionality
  class Campaign
    class << self
      def active(options = {})
        response = EmailDirect.get '/Campaigns', :query => options
        Hashie::Mash.new(response)
      end

      def drafts(options = {})
        response = EmailDirect.get '/Campaigns/Drafts', :query => options
        Hashie::Mash.new(response)
      end

      def sent(options = {})
        response = EmailDirect.get '/Campaigns/Sent', :query => options
        Hashie::Mash.new(response)
      end

      def sending(options = {})
        response = EmailDirect.get '/Campaigns/Sending', :query => options
        Hashie::Mash.new(response)
      end

      def scheduled(options = {})
        response = EmailDirect.get '/Campaigns/Scheduled', :query => options
        Hashie::Mash.new(response)
      end

      def all(options = {})
        response = EmailDirect.get '/Campaigns/All', :query => options
        Hashie::Mash.new(response)
      end

      def create(name, creative_id, subject, from_name, publication_id, options = {})
        options.merge! :Name => name, :CreativeID => creative_id, :Subject => subject, :FromName => from_name, :PublicationID => publication_id
        response = EmailDirect.post '/Campaigns', :body => options.to_json
        Hashie::Mash.new(response)
      end
    end

    attr_reader :campaign_id

    def initialize(campaign_id)
      @campaign_id = campaign_id
    end

    def details
      response = get
      Hashie::Mash.new(response)
    end

    def message
      response = get 'Email'
      Hashie::Mash.new(response)
    end

    def links
      response = get 'Links'
      Hashie::Mash.new(response)
    end

    def recipients(options = {})
      response = get 'Recipients', options
      Hashie::Mash.new(response)
    end

    def opens(options = {})
      response = get 'Opens', options
      Hashie::Mash.new(response)
    end

    def clicks(options = {})
      response = get 'Clicks', options
      Hashie::Mash.new(response)
    end

    def removes(options = {})
      response = get 'Removes', options
      Hashie::Mash.new(response)
    end

    def complaints(options = {})
      response = get 'Complaints', options
      Hashie::Mash.new(response)
    end

    def soft_bounces(options = {})
      response = get 'SoftBounces', options
      Hashie::Mash.new(response)
    end

    def hard_bounces(options = {})
      response = get 'HardBounces', options
      Hashie::Mash.new(response)
    end

    def update(name, creative_id, subject, from_name, publication_id, options = {})
      options.merge! :Name => name, :CreativeID => creative_id, :Subject => subject, :FromName => from_name, :PublicationID => publication_id
      response = EmailDirect.put uri_for, :body => options.to_json
      Hashie::Mash.new(response)
    end

    def schedule(schedule_date)
      options = { :CampaignID => campaign_id, :ScheduleDate => schedule_date.strftime('%FT%TZ') }
      response = EmailDirect.post '/Campaigns/Schedule', :body => options.to_json
      Hashie::Mash.new(response)
    end

    def cancel
      response = EmailDirect.post '/Campaigns/Cancel', :body => campaign_id.to_json
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
      "/Campaigns/#{campaign_id}#{action}"
    end
  end
end

