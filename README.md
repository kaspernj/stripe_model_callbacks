# StripeModelCallbacks
Stripe database models using ActiveRecord, Stripe event webhooks synchronization and PublicActivity.

This is supposed to make it easier implementing a full blown Stripe implementation into your application,
so that you can code your app using ActiveRecord and all your favorite gems without having to mess around
with webhooks, custom and complicated tests and more.

The purpose is that the complicated webhook stuff is done by this gem, and you can trust our tests to work,
so you dont have to write those thousand of lines yourself.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'stripe_model_callbacks'
```

And then execute:
```bash
$ bundle
```

You also need to install and setup the gems `public_activity`, `stripe` and `stripe_event`. Do this:

Install the migration for Public Activity, which will provide logging:
```bash
rails g public_activity:migration
```

Do something like this in `config/routes.rb`:
```ruby
Rails.application.routes.draw do
  mount StripeEvent::Engine => "/stripe-events"
end
```

Do something like this in `config/initializers/stripe.rb`:
```ruby
Stripe.api_key = "fake-key"
StripeEvent.signing_secret = "fake-signing-key"

Rails.configuration.stripe = {
  publishable_key: "fake-public-key",
  secret_key: "fake-secret-key"
}

StripeEvent.configure do |events|
  StripeModelCallbacks::ConfigureService.execute!(events: events)
end
```

Add the migrations for the Stripe models to your project like this:
```bash
rake stripe_model_callbacks:install:migrations
```

You should set up your Stripe account to post events to your website using a URL that looks something like this:
`https://www.yourdomain.com/stripe-events`.

Your application should now receive event webhooks from Stripe and then create, update, mark as deleted,
log and more automatically using the ActiveRecord models.

## Usage

To see a list of transfers for example, you do something like this as you would with any given model:

```ruby
StripeTransfer.where("stripe_transfers.created > ?", Time.zone.now.beginning_of_month)
```

You can inspect the tables and see which tables and columns that are available. Most of it alligns with
the attributes mentioned in Stripe's own API.

## Testing

If you need some FactoryBot factories, then you can do like this in `spec/rails_helper.rb`:
```ruby
require "stripe_model_callbacks/factory_bot_definitions"
```

You can take a look at the factories here:
https://github.com/kaspernj/stripe_model_callbacks/tree/master/spec/factories

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
