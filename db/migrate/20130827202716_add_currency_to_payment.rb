class AddCurrencyToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :currency, :string
  end
end
