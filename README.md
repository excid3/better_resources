# BetterResources

One crappy thing about Rails resources is that when a user creates a new
record or edits an existing record, the forms POST or PATCH to different
URLs than the forms. This means that if something goes wrong and the
user tries to refresh the page, they receive a 404 because GET for
/posts does not exist.

This gem addresses that by adding `better_resources` routes,
`better_form_with` and `better_form_for`. These generate the proper URLs
and forms to handle this problem.

We opted not to override the Rails helpers so that these don't interfer
at all with your existing code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'better_resources'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install better_resources

## Usage

Then you can change your routes to use `better_resources`

```ruby
# config/routes.rb
better_resources :posts
```

And your forms can now use `better_form_with` or `better_form_for` to
match the routes:

```ruby
<%= better_form_for(user) do |form| %>
<% end %>

<%# or %>

<%= better_form_with(model: user) do |form| %>
<% end %>
```

And that's it!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/better_resources. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the BetterResources project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/better_resources/blob/master/CODE_OF_CONDUCT.md).
