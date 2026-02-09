require "json"

Portfolio.destroy_all
Placement.destroy_all

path = Rails.root.join("data", "level_1", "portfolios.json")
data = JSON.parse(File.read(path))

data["contracts"].each do |contract|
  portfolio = Portfolio.create!(
    label: contract["label"],
    kind:  contract["type"],
    amount: contract["amount"]
  )

  (contract["lines"] || []).each do |line|
    Placement.create!(
      portfolio: portfolio,
      kind: line["type"],
      isin: line["isin"],
      label: line["label"],
      price: line["price"],
      share: line["share"],
      amount: line["amount"],
      srri: line["srri"]
    )
  end
end
