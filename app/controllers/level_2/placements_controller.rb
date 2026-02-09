class Level2::PlacementsController < ApplicationController
  def update
    action_type = params.require(:action_type)
    portfolio_label = params.require(:portfolio_label)
    amount = params.require(:amount).to_d

    portfolio = Portfolio.find_by!(label: portfolio_label)

    case action_type
    when "deposit"
      isin = params.require(:isin)
      placement = portfolio.placements.find_by!(isin: isin)
      placement.update!(amount: placement.amount + amount)

    when "withdraw"
      isin = params.require(:isin)
      placement = portfolio.placements.find_by!(isin: isin)
      placement.update!(amount: placement.amount - amount)

    when "transfer"
      from_isin = params.require(:from_isin)
      to_isin   = params.require(:to_isin)

      from_placement = portfolio.placements.find_by!(isin: from_isin)
      to_placement   = portfolio.placements.find_by!(isin: to_isin)

      from_placement.update!(amount: from_placement.amount - amount)
      to_placement.update!(amount: to_placement.amount + amount)

    else
      render json: { error: "Error" }, status: :bad_request and return
    end

    head :ok
  end
end
