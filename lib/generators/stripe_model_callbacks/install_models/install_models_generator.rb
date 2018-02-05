require "rails/generators/migration"

module StripeModelCallbacks::Generators
  class InstallModelsGenerator < ::Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path("../templates", __FILE__)
    desc "add the migrations"

    def self.next_migration_number(_path)
      if @prev_migration_nr
        @prev_migration_nr += 1
      else
        @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
      end

      @prev_migration_nr.to_s
    end

    def copy_migrations
      migration_template "create_stripe_customers.rb", "db/migrate/create_stripe_customers.rb"
      migration_template "create_stripe_customer_subscriptions.rb", "db/migrate/create_stripe_customer_subscriptions.rb"
      migration_template "create_stripe_plans.rb", "db/migrate/create_stripe_plans.rb"
    end
  end
end
