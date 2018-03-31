FactoryBot.define do
  factory :route_point do
    city_id        1
    point_type     0
    point_at     { Faker::Date.forward }
    route_id       1
  end
end