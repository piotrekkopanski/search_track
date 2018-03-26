class RoutePoint < ApplicationRecord
  belongs_to :route

  validates :city_id, :point_type, :point_at, presence: true
  validates_numericality_of :city_id, greater_than: 0

  enum point_type: { start_point: 0, intermediate: 1, finish_point: 2 }

end
