class Level1::PortfoliosController < ApplicationController
  def index
    path = Rails.root.join("data", "level_1", "portfolios.json")
    render json: JSON.parse(File.read(path))
  end
end
