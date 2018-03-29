class SearchRoutesService
  
  def self.check_arguments(route_type, start_city_id, finish_city_id)
  	@error_messages = []
    @error_messages.push('Route type must  be driver or passenger') if ['driver', 'passenger'].exclude?(route_type)
    @error_messages.push("Start City must exist") if RoutePoint.pluck(:city_id).exclude?(start_city_id)
    @error_messages.push("Finish City must exist") if RoutePoint.pluck(:city_id).exclude?(finish_city_id)	 	
  end

  public

    def self.search(route_type, start_city_id, finish_city_id)
      check_arguments(route_type, start_city_id, finish_city_id)
      if @error_messages.empty?
        check_start_city = "((route_points.point_type = 0 OR route_points.point_type = 1) AND (route_points.city_id = #{start_city_id}))"
        check_finish_city = "((route_points.point_type = 1 OR route_points.point_type = 2) AND (route_points.city_id = #{finish_city_id}))"
        Route.where(route_type: route_type).joins(:route_points).where("(#{check_start_city} OR #{check_finish_city})").group_by{ |e| e }.select { |k, v| v.size > 1 }.map(&:first)
      else
      	@error_messages.join(", ")
      end
    end

end
