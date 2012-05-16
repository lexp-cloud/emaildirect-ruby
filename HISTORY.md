## 1.3.2 (May 16, 2012)
* Fixed url for database resource (bgetting)

## 1.3.1 (Apr. 5, 2012)
* Fix bug where exceptions could be raised with empty error messages.

## 1.3.0 (Feb. 9th, 2012)
* Ruby 1.9 compatibility

## 1.2.1 (Jan. 19th, 2012)
* Relay emails were losing spaces between words because EmailDirect strips out newlines.

## 1.2.0 (Dec. 21st, 2011)
* Add EmailDirect.disable to disable talking to the EmailDirect server (requires fakeweb gem).

## 1.1.0 (Dec. 20th, 2011)

* Add EmailDirect::Subscriber#update_custom_field and EmailDirect::Subscriber#update_custom_fields as a way to quickly update one or more custom fields.
* Custom Fields can now be passed as a regular ruby hash to any of the Subscriber methods and it will be converted to the correct JSON format.
* Authentication is done using a header instead of basic auth so FakeWeb is easier to use.

## 1.0.0 (Dec. 12th, 2011)

* Initial release
