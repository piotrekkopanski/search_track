class Route < ApplicationRecord
  has_many :route_points

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: { scope: :route_type, message: "should be one per route type" }
  validates :route_type, presence: true
  validates_inclusion_of :seats, :in => 1..4

  enum route_type: { driver: 0, passenger: 1 }

  def to_s
  	name
  end

end
