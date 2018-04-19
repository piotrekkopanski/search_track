# Service to search routes
class SearchRoutesService
  def self.check_arguments(route_type, start_city_id, finish_city_id)
    @error_messages = []
    @error_messages.push('Route type must  be driver or passenger') unless route_type.in? %w[driver passenger].map(&:freeze).freeze
    @error_messages.push('Start City must exist') if RoutePoint.pluck(:city_id).exclude?(start_city_id)
    @error_messages.push('Finish City must exist') if RoutePoint.pluck(:city_id).exclude?(finish_city_id)
    @error_messages.push("You can't go to the same city") if start_city_id == finish_city_id
  end

  def self.search(route_type, start_city_id, finish_city_id)
    check_arguments(route_type, start_city_id, finish_city_id)
    if @error_messages.empty?
      start_city_in_start_point = "(id IN (SELECT route_id FROM route_points WHERE (point_type = 0 AND city_id = #{start_city_id})) AND  (id IN (SELECT route_id FROM route_points WHERE (point_type IN (1,2) AND city_id = #{finish_city_id}) ))"
      start_city_in_intermediate_point = "(id IN (SELECT route_id FROM route_points WHERE (point_type = 1 AND city_id = #{start_city_id}) ) AND (id IN (SELECT route_id FROM route_points WHERE (point_type = 2 AND city_id = #{finish_city_id}) ))))"
      return Route.where(route_type: route_type).where("#{start_city_in_start_point} OR #{start_city_in_intermediate_point}")
    else
      return @error_messages.join(', ')
    end
  end

end