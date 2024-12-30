# Pxpayplus

Pxpayplus is a Ruby gem that provides an interface to interact with the PXPay Plus API. This gem simplifies the process of integrating PXPay Plus API into your Ruby applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pxpayplus'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install pxpayplus

## Configuration

Before using the gem, you need to configure it with your Pxpayplus credentials:

```ruby
Pxpayplus.configure do |config|
  config.secret_key = 'your_secret_key'
  config.merchant_code = 'your_merchant_code'
  config.api_hostname = 'your_api_hostname'
end
```

## Usage

Here's a basic example of how to use Pxpayplus:

> **Note:** The examples below do not use all the parameters defined by PXPay Plus API document. Please refer to the official API documentation for a complete list of parameters and their usage.

```ruby
require 'pxpayplus'

# Initialize the Pxpayplus client
client = Pxpayplus::Client.new

# Create an auth binding order
auth_order_params = {
  mer_order_no: 'mer_order_no',
  amount: 1000,
  device_type: 1,
  req_time: 'req_time'
}
auth_order_response = client.create_auth_order(auth_order_params)
puts "Auth Order Response: #{auth_order_response}"

# Debit an auth binding order
debit_params = {
  mer_trade_no: 'mer_trade_no',
  auth_binding_no: 'auth_binding_no',
  mer_order_no: 'mer_order_no',
  amount: 1000,
  req_time: 'req_time'
}
debit_response = client.debit(debit_params)
puts "Debit Response: #{debit_response}"

# Unbind an auth binding order
unbind_params = {
  mer_order_no: 'mer_order_no',
  auth_binding_no: 'auth_binding_no',
  mer_member_token: 'mer_member_token',
  req_time: 'req_time'
}
unbind_response = client.unbind(unbind_params)
puts "Unbind Response: #{unbind_response}"

# Refund an order
refund_params = {
  mer_trade_no: 'mer_trade_no',
  px_trade_no: 'px_trade_no',
  refund_mer_trade_no: 'refund_mer_trade_no',
  amount: 1000,
  req_time: 'req_time'
}
refund_response = client.refund(refund_params)
puts "Refund Response: #{refund_response}"

# Check order status
check_order_status_params = {
  mer_trade_no: 'mer_trade_no',
  req_time: 'req_time'
}
check_order_status_response = client.check_order_status(check_order_status_params)
puts "Check Order Status Response: #{check_order_status_response}"

# Update debit time
update_debit_time_params = {
  mer_trade_no: 'mer_trade_no',
  px_trade_no: 'px_trade_no',
  req_time: 'req_time'
}
update_debit_time_response = client.update_debit_time(update_debit_time_params)
puts "Update Debit Time Response: #{update_debit_time_response}"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yknli/pxpayplus.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
