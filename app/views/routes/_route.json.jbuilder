json.extract! route, :id, :name, :route_type, :seats, :created_at, :updated_at
json.url route_url(route, format: :json)
