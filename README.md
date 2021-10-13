# CorePro API SDK

Ruby SDK for working with [CorePro](https://docs.corepro.io)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'core_pro'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install core_pro

## Usage

A subset of the CorePro resources are provided with this SDK:

 * `CorePro::Program`
 * `CorePro::Customer`
 * `CorePro::Account`
 * `CorePro::ExternalAccount`
 * `CorePro::Transfer`
 * `CorePro::Transaction`

These resources have implemented the following methods to allow API operations:
 * `#all`
 * `#find`
 * `#create`
 * `#onboard(kyc_vendor)` (only for `CorePro::Customer`)

Here's an example on how to create a customer, an account,
and initiate a transfer:
```ruby
require 'core_pro'

customer = CorePro::Customer.create(
  firstName: 'James',
  lastName: 'Bond',
  isSubjectToBackupWithholding: false,
  isOptedInToBankCommunication: false,
  isDocumentsAccepted: true
).reload

customer.onboard(:socure)

old_account = CorePro::Account.find(customer.customerId, <OLD_ACCOUNT_ID>)

account = CorePro::Account.create(
  customerId: customer.customerId,
  name: 'Test',
  productId: <PRODUCT_ID>
)

transfer = CorePro::Transfer.create(
  amount: 1.0,
  customerId: customer.customerId,
  fromId: old_account.accountId,
  toId: account.accountId
)

transactions = CorePro::Transaction.all(
  customerId,
  accountId,
  '2021-12-21',
  '2021-12-22'
)
```

### Configuration

The API keys will be loaded from your environment variables:

 * `COREPRO_KEY`
 * `COREPRO_SECRET`
 * `COREPRO_ENDPOINT` defaults to `https://api.corepro.io`

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/HeyBetter/core_pro. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
