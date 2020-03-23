class AddAmountPaidAndRemainingAndInvoiceUrlAndPdf < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_invoices, :amount_paid_cents, :integer
    add_column :stripe_invoices, :amount_paid_currency, :string
    add_column :stripe_invoices, :amount_remaining_cents, :integer
    add_column :stripe_invoices, :amount_remaining_currency, :string
    add_column :stripe_invoices, :collection_method, :string
    add_column :stripe_invoices, :hosted_invoice_url, :string
    add_column :stripe_invoices, :invoice_pdf, :string
  end
end
