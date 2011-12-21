# emaildirect

A ruby library which implements the complete functionality of the REST (v5) [Email Direct API](https://docs.emaildirect.com).

## Installation

### Plain ruby
    gem install emaildirect
    require 'emaildirect'
    EmailDirect.api_key = 'your_api_key'

### Rails integration
In your gemfile:

    gem 'emaildirect'

In an initializer:

    EmailDirect.api_key = 'your_api_key'

## Examples

### Retrieve a list of all your publications.

    EmailDirect::Publication.all.Publications.each do |pub|
      puts "#{pub.PublicationID}: #{pub.Name}"
    end

Results in:
    
    1: Publication One
    2: Publication Two

### Create, then remove a Publication

    response = EmailDirect::Publication.create('Test', :Description => 'Test Publication')
    sub = EmailDirect::Publication.new(response.publicationID)
    sub.delete

### Updating a subscriber's custom fields

A single attribute:

    EmailDirect::Subscriber.new(email).update_custom_field :FirstName, 'Pat'

Multiple attributes:

    EmailDirect::Subscriber.new(email).update_custom_fields :FirstName => 'Pam', :LastName => 'Sinivas'

When creating a subscriber

    EmailDirect::Subscriber.create(email, :Publications => [1], :CustomFields => { :FirstName => 'Pam', :LastName => 'Sinivas' }

### ActionMailer integration
You can use send your ActionMailer email through Email Direct using their Relay Send functionality by setting up a new delivery method in an initalizer:

     ActionMailer::Base.add_delivery_method :emaildirect, EmailDirect::Mailer,
                                            :category_id => 1,
                                            :options   => { :Force => true }

And in your ActionMailer class:

    defaults :delivery_method => :emaildirect

or for just a particular message:

    def welcome(user) do
      mail :to => user.email,
           :delivery_method => :emaildirect
    end

### Handling errors
If the emaildirect API returns an error, an exception will be thrown. For example, if you attempt to create a subscriber with an invalid email address:

    begin
      response = EmailDirect::Subscriber.create('bademail')
      rescue EmailDirect::BadRequest => br
        puts "Bad request error: #{br}"
        puts "Error Code:    #{br.data.ErrorCode}"
        puts "Error Message: #{br.data.Message}"
      rescue Exception => e
        puts "Error: #{e}"
    end

Results in:

    Bad request error: The EmailDirect API responded with the following error - 101: Invalid Email Address
    Error Code:    101
    Error Message: Invalid Email Address

### Disabling in Development/Test
A helper method is provided to disable talking to the EmailDirect REST server (requires the [Fakeweb gem](http://fakeweb.rubyforge.org/))

    EmailDirect.disable

### Expected input and output
The best way of finding out the expected input and output of a particular method in a particular class is to read the [API docs](https://docs.emaildirect.com)
and take a look at the code for that function.

## Credits
- Jason Rust
- [createsend-ruby](https://github.com/campaignmonitor/createsend-ruby) library for inspiration on how to write a decent REST API wrapper.
