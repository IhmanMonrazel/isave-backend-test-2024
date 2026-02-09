class Portfolio < ApplicationRecord
  has_many :placements, dependent: :destroy
end
