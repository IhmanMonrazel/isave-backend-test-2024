class CreatePortfolios < ActiveRecord::Migration[7.1]
  def change
    create_table :portfolios do |t|
      t.string :label
      t.string :kind
      t.decimal :amount

      t.timestamps
    end
  end
end
