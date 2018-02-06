rails db:environment:set RAILS_ENV=development
rm db/migrate/*_stripe_*
rake stripe_model_callbacks:install:migrations
rake db:drop
rake db:migrate
