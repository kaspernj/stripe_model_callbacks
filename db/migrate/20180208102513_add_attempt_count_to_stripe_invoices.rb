class AddAttemptCountToStripeInvoices < ActiveRecord::Migration[5.1]
  def change
    add_column :stripe_invoices, :attempt_count, :integer
    add_column :stripe_invoices, :ending_balance, :integer
    add_column :stripe_invoices, :starting_balance, :integer
  end
end
