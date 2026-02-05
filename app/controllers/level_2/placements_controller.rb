class Level2::PlacementsController < ApplicationController
  # Chemin vers portfolios.json
  DATA_PATH = Rails.root.join("data", "level_1", "portfolios.json")

  # Appelé par PATCH
  def update
    # Lecture + transformation en Hash + récupératin de la clé "contracts"
    data = JSON.parse(File.read(DATA_PATH))
    contracts = data.fetch("contracts")

    # Récupération, label portefeuille + "deposit"/"withdraw"/"transfer" + montant et conversion en float
    portfolio_label = params.fetch("portfolio_label")
    action_type     = params.fetch("action_type")
    amount          = params.fetch("amount").to_f

    # Trouve portefeuille dont "label" correspond sinon error
    contract = contracts.find { |c| c["label"] == portfolio_label }
    return render json: { error: "Portfolio not found" }, status: :not_found if contract.nil?

    # CTO ou CTA seuls choix possible sinon error
    unless %w[CTO PEA].include?(contract["type"])
      return render json: { error: "Portfolio not eligible (must be CTO or PEA)" }, status: :unprocessable_entity
    end

    # Récupère "lines" sinon liste vide
    lines = contract["lines"] || []

    # Oriente selon action demandé
    case action_type

    # Récupère isin + à ligne à modifier+ ajoute à amount
    when "deposit"
      isin = params.fetch("isin")
      line = lines.find { |l| l["isin"] == isin }
      return render json: { error: "Instrument not found" }, status: :not_found if line.nil?

      line["amount"] = line.fetch("amount").to_f + amount

      # Récupère isin + ligne à modifier + montant actuel + error si montant insuffisant + retire
    when "withdraw"
      isin = params.fetch("isin")
      line = lines.find { |l| l["isin"] == isin }
      return render json: { error: "Instrument not found" }, status: :not_found if line.nil?

      current = line.fetch("amount").to_f
      return render json: { error: "Not enough money" }, status: :unprocessable_entity if current < amount

      line["amount"] = current - amount

      # Récupère les deux isin + les deux lignes à modifier + vérifications présence + soustrait de from et ajoute ur to
    when "transfer"
      from_isin = params.fetch("from_isin")
      to_isin   = params.fetch("to_isin")

      from_line = lines.find { |l| l["isin"] == from_isin }
      to_line   = lines.find { |l| l["isin"] == to_isin }

      return render json: { error: "From instrument not found" }, status: :not_found if from_line.nil?
      return render json: { error: "To instrument not found" }, status: :not_found if to_line.nil?

      from_current = from_line.fetch("amount").to_f
      return render json: { error: "Not enough money" }, status: :unprocessable_entity if from_current < amount

      from_line["amount"] = from_current - amount
      to_line["amount"]   = to_line.fetch("amount").to_f + amount

    else
      return render json: { error: "Unknown action_type" }, status: :unprocessable_entity
    end

    # Recalcul du amount
    contract["amount"] = lines.sum { |l| l.fetch("amount").to_f }

    # Écrit le JSON modifié + renvoi JSON mis à jour
    File.write(DATA_PATH, JSON.pretty_generate(data))

    render json: data
  end
end
