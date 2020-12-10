class Meter < ApplicationRecord
  belongs_to :region
  has_many :readings
end
