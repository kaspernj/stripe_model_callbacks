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
      migration_template "create_stripe_charges.rb", "db/migrate/create_stripe_charges.rb"
      migration_template "create_stripe_customers.rb", "db/migrate/create_stripe_customers.rb"
      migration_template "create_stripe_discounts.rb", "db/migrate/create_stripe_discounts.rb"
      migration_template "create_stripe_invoices.rb", "db/migrate/create_stripe_invoices.rb"
      migration_template "create_stripe_invoice_items.rb", "db/migrate/create_stripe_invoice_items.rb"
      migration_template "create_stripe_orders.rb", "db/migrate/create_stripe_orders.rb"
      migration_template "create_stripe_order_items.rb", "db/migrate/create_stripe_order_items.rb"
      migration_template "create_stripe_plans.rb", "db/migrate/create_stripe_plans.rb"
      migration_template "create_stripe_refunds.rb", "db/migrate/create_stripe_refunds.rb"
      migration_template "create_stripe_sources.rb", "db/migrate/create_stripe_sources.rb"
      migration_template "create_stripe_subscriptions.rb", "db/migrate/create_stripe_subscriptions.rb"
    end
  end
end
