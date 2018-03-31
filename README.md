a. To prepare the database

   In Your terminal:
 * git clone https://github.com/piotrekkopanski/search_track.git
 * bundle install
 * rake db:migrate
 * rails s

   To add new route:
 * go to http://localhost:3000/routes/new
 * fill in the name field, which can contain a maximum 100 characters and should be one per route type
 * select one of the two route types (driver, passenger)
 * if You want, enter the size of seats from 1 to 4
 * and click the button "Create Route" 

   To add new route point
 * Before, You must add at least one route 
 * go to http://localhost:3000/route_points/new
 * select one of the routes, that will be associated with the route point, remember that the route must be unique for types start_point and finish_point
 * enter the city id, which must be greater than 0
 * select one of the three point types (start_point, intermediate, finish_point)
 * enter the date time in point_at
 * and click the button "Create Route point"

b. Application has service SearchRoutesService, which let to search routes by route type, start city id and finish city id, for example:
  To search routes with route type driver, start city in city id = 1 and finish city in city id = 2 :

    In Your terminal:
    * rails c
    * SearchRoutesService.search('driver',1,2)