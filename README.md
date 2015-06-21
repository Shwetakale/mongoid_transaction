# MongoidTransaction

This gem is for using Transaction API's provided by TokuMx along with mongoid.

##DO NOT USE THIS GEM If you are seeing this line. Work in progress.

## Installation


Add this line to your application's Gemfile:

```ruby
gem 'mongoid_transaction', git:'git@github.com:Shwetakale/mongoid_transaction.git'
```

And then execute:

    $ bundle

## Usage

    Mongoid::Transaction.execute do
        User.create!(name: user_name)
        Parent.create!(name: parent_name)
    end

Currently only those methods are supported which raise exception on failure. (For ex. create!, update_attributes!, set, update_attribute)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[Shwetakale]/mongoid_transaction. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

