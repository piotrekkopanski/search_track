class Route < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }
  validates :route_type, presence: true
  validates_inclusion_of :seats, :in => 1..4

  enum route_type: { driver: 0, passenger: 1 }

end
