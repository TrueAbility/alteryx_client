# AlteryxClient

Validates user existance and eligibility in Alteryx Community by community email id.


Usage of the client:
```ruby
AlteryxClient.configure do |config|
  config.session_url = "alteryx_session_url"
  config.api_url = "alteryx_api_url"
  config.username = "alteryx_username"
  config.password = "alteryx_password"
  config.designer_expert_uuid ="uuid use to validate eligibility"
end
```

Get Alteryx Comminuty user:
```ruby
alteryx_client = AlteryxClient::Client.new
alteryx_user = alteryx_client.get_user_by_id("alteryx_user_id")
```

Alteryx may save ta-web user uuid. If they have one, they will send it back inside alteryx_user.uuid.


## Installation

Add this line to your application's Gemfile:

```ruby
gem "alteryx_client"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alteryx_client


Bug reports and pull requests are welcome on GitHub at https://github.com/Trueability/ta-alteryx-client.

## Copyright and Ownership

© 2024 Trueability

All code in this repository is owned by Trueability and is provided under the terms of the MIT License. By contributing to this repository, you agree that your contributions will be licensed under the same license.
