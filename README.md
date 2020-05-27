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
bundle
```

You also need to install and setup the gems `public_activity`, `stripe` and `stripe_event`. Do this:

Install the migration for Public Activity, which will provide logging:
```bash
rails g public_activity:migration
```

You can install the migrations (or update an existing installation) with this command:
```bash
rails stripe_model_callbacks:install:migrations
```

Do something like this in `config/routes.rb`:
```ruby
Rails.application.routes.draw do
  mount StripeEvent::Engine => "/stripe-events"
end
```

Do something like this in `config/initializers/stripe.rb`:
```ruby
Stripe.api_key = ENV.fetch("STRIPE_PUBLIC_KEY")
StripeEvent.signing_secret = ENV.fetch("STRIPE_SIGNING_KEY")

Rails.configuration.stripe = {
  publishable_key: ENV.fetch("STRIPE_PUBLIC_KEY"),
  secret_key: ENV.fetch("STRIPE_SECRET_KEY")
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

You can use a service like Ultrahook to set up a proxy for your local development machine to test against.

## Usage

### Queries with ActiveRecord

To see a list of transfers, you can do something like this, as you would with any given model:

```ruby
StripeTransfer.where("stripe_transfers.created > ?", Time.zone.now.beginning_of_month)
```

You can inspect the tables and see which tables and columns that are available. Most of it alligns with
the attributes mentioned in Stripe's own API.

### Updating on Stripe

You can update the data on Stripe like this:

```ruby
stripe_subscription = StripeSubscription.find(id)
stripe_subscription.update_on_stripe!(tax_percent: 10)
```

Create a record from a Stripe object

```ruby
object = Stripe::Subscription.retrieve(id)
stripe_subscription = StripeSubscription.create_from_stripe!(object)
```

Sync data from Stripe:
```ruby
stripe_subscription = StripeSubscription.find(id)
stripe_subscription.reload_from_stripe!
```

Delete on Stripe:
```ruby
stripe_subscription = StripeSubscription.find(id)
stripe_subscription.destroy_on_stripe!
```

Convert model to a Stripe object:
```ruby
stripe_subscription = StripeSubscription.find(id)
stripe_subscription.to_stripe.delete(at_period_end: true)

# We should probably reload so the model reflect that change instantly (else it should receive it through a sync event in a short while)
stripe_subscription.reload_from_stripe!
```

## Testing

### Factories

If you need some FactoryBot factories, then you can do like this in `spec/rails_helper.rb`:
```ruby
require "stripe_model_callbacks/factory_bot_definitions"
```

You can take a look at the factories here:
https://github.com/kaspernj/stripe_model_callbacks/tree/master/spec/factories

### Mock events

You can mock Stripe events by using the helper method `mock_stripe_event` by including this helper:

```
RSpec.configure do |config|
  config.include StripeModelCallbacks::EventMocker
end
```

You can find all the events you can mock here: https://github.com/kaspernj/stripe_model_callbacks/tree/master/spec/fixtures/stripe_events

You can mock the events by their file name like this:
```ruby
mock_stripe_event("charge.refunded")
```

You can change the data of the event like this:
```ruby
mock_stripe_event("invoice.created", data: {object: {discount: {"customer": "cus_CLI9d5IHGcdWBY"}}})
```

## Contributing
Contribution directions go here.

# capybara-webkit installation issue
Instruction how to solve the issue: https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit#macOS-catalina-1015

# Database schema changes
  1. Add migration to `/db/migrate`: ```rails g migration AddStripeIdUniqToStripeInvoices```
  2. Go to directory: `spec/dummy`
  3. Run ```rails stripe_model_callbacks:install:migrations``` to copy missing migrations
  4. Run `rails db:migrate` to apply schema changes

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
