## 1.1.0 (Dec. 20th, 2011)

* Added EmailDirect::Subscriber#update_custom_field and EmailDirect::Subscriber#update_custom_fields as a way to quickly update one or more custom fields.
* Custom Fields can now be passed as a regular ruby hash to any of the Subscriber methods and it will be converted to the correct JSON format.
* Authentication is done using a header instead of basic auth so FakeWeb is easier to use.

## 1.0.0 (Dec. 12th, 2011)

* Initial release
