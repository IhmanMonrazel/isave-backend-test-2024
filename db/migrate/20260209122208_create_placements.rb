class CreatePlacements < ActiveRecord::Migration[7.1]
  def change
    create_table :placements do |t|
      t.references :portfolio, null: false, foreign_key: true
      t.string :kind
      t.string :isin
      t.string :label
      t.decimal :price
      t.decimal :share
      t.decimal :amount
      t.integer :srri

      t.timestamps
    end
  end
end
