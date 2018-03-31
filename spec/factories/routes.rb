FactoryBot.define do
  factory :route do
    sequence(:name)  { |n| "track #{n}" }
    route_type       "driver"
    seats             2 
  end
end