class Level1::PortfoliosController < ApplicationController
  def index
    portfolios = Portfolio.includes(:placements)

    render json: {
      contracts: portfolios.map { |p|
        {
          label: p.label,
          type: p.kind,
          amount: p.amount.to_f,
          lines: p.placements.map { |pl|
            {
              type: pl.kind,
              isin: pl.isin,
              label: pl.label,
              price: pl.price.to_f,
              share: pl.share.to_f,
              amount: pl.amount.to_f,
              srri: pl.srri
            }
          }
        }
      }
    }
  end
end
