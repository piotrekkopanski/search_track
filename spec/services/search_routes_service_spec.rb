require 'rails_helper'

RSpec.describe SearchRoutesService, :type => :service do
  before do
    FactoryBot.create(:route, name: 'track 1',route_type: 'driver', seats: 1)
    FactoryBot.create(:route, name: 'track 2',route_type: 'driver', seats: 1)
    FactoryBot.create(:route, name: 'track 3',route_type: 'passenger', seats: 1)
    FactoryBot.create(:route, name: 'track 4',route_type: 'passenger', seats: 1)
    FactoryBot.create(:route, name: 'track 5',route_type: 'passenger', seats: 1)
    FactoryBot.create(:route_point, city_id: 1,point_type: 0, route_id: 1)
    FactoryBot.create(:route_point, city_id: 2,point_type: 1, route_id: 1)
    FactoryBot.create(:route_point, city_id: 3,point_type: 2, route_id: 1)
    FactoryBot.create(:route_point, city_id: 4,point_type: 0, route_id: 2)
    FactoryBot.create(:route_point, city_id: 5,point_type: 1, route_id: 2)
    FactoryBot.create(:route_point, city_id: 6,point_type: 2, route_id: 2)
    FactoryBot.create(:route_point, city_id: 7,point_type: 0, route_id: 3)
    FactoryBot.create(:route_point, city_id: 8,point_type: 1, route_id: 3)
    FactoryBot.create(:route_point, city_id: 9,point_type: 2, route_id: 3)
    FactoryBot.create(:route_point, city_id: 10,point_type: 0, route_id: 4)
    FactoryBot.create(:route_point, city_id: 11,point_type: 1, route_id: 4)
    FactoryBot.create(:route_point, city_id: 12,point_type: 2, route_id: 4)
    FactoryBot.create(:route_point, city_id: 11,point_type: 0, route_id: 5)
    FactoryBot.create(:route_point, city_id: 12,point_type: 1, route_id: 5)
    FactoryBot.create(:route_point, city_id: 13,point_type: 2, route_id: 5)
    FactoryBot.create(:route_point, city_id: 14,point_type: 1, route_id: 5)
    FactoryBot.create(:route_point, city_id: 15,point_type: 1, route_id: 1)
  end

  context "without valid arguments" do
    it "wrong route_type, start city doesn't exist, finish city doesn't exist" do
      expect(  SearchRoutesService.search('not_exist_route_type',100,200) ).to eq('Route type must  be driver or passenger, Start City must exist, Finish City must exist')
    end

    it "start city doesn't exist, finish city doesn't exist" do
      expect(  SearchRoutesService.search('driver',100,200) ).to eq('Start City must exist, Finish City must exist')
    end

    it "start city doesn't exist, finish city doesn't exist, start and finish is the same city" do
      expect(  SearchRoutesService.search('driver',200,200) ).to eq("Start City must exist, Finish City must exist, You can't go to the same city" )
    end

    it "finish city doesn't exist" do
      expect(  SearchRoutesService.search('driver',5,200) ).to eq('Finish City must exist')
    end

    it "start city doesn't exist" do
      expect(  SearchRoutesService.search('driver',100,2) ).to eq('Start City must exist')
    end

    it "not search route with  start_city in intermediate and finish city in intermediate" do
      expect(  SearchRoutesService.search('driver',2,2) ).to eq("You can't go to the same city")
    end

    it "not search route with  start_city in start_point and finish city in start_point" do
      expect(  SearchRoutesService.search('driver',1,1) ).to eq("You can't go to the same city")
    end

    it "not search route with  start_city in finish_point and finish city in finish_point" do
      expect(  SearchRoutesService.search('driver',3,3) ).to eq("You can't go to the same city")
    end
  end

  context "with valid arguments" do
    it "search route with route_type driver start_city in start_point finish city in finish_point" do
      expect(  SearchRoutesService.search('driver',1,3) ).to eq(Route.where(name: 'track 1'))
    end 

    it "search route with route_type driver start_city in start_point finish city in intermediate" do
      expect(  SearchRoutesService.search('driver',1,2) ).to eq(Route.where(name: 'track 1'))
    end 

    it "search route with route_type driver start_city in intermediate finish city in finish_point" do
      expect(  SearchRoutesService.search('driver',2,3) ).to eq(Route.where(name: 'track 1'))
    end

    it "search route with route_type passenger start_city in start_point finish city in finish_point" do
      expect(  SearchRoutesService.search('passenger',7,9) ).to eq(Route.where(name: 'track 3'))
    end 

    it "search route with route_type passenger start_city in start_point finish city in intermediate" do
      expect(  SearchRoutesService.search('passenger',7,8) ).to eq(Route.where(name: 'track 3'))
    end 

    it "search route with route_type passenger start_city in intermediate finish city in finish_point" do
      expect(  SearchRoutesService.search('passenger',8,9) ).to eq(Route.where(name: 'track 3'))
    end

    it "search routes with start_city in start_point or intermediate finish city in intermediate or finish_point" do
      expect(  SearchRoutesService.search('passenger',11,12) ).to eq(Route.where(name: 'track 4') + Route.where(name: 'track 5'))
    end

    it "not search route with route_type driver start_city in finish_point" do
      expect(  SearchRoutesService.search('driver',3,1) ).to eq([])
    end 

    it "not search route with route_type driver finish city in start_city" do
      expect(  SearchRoutesService.search('driver',3,1) ).to eq([])
    end
    
    it "not search route with route_type passenger start_city in finish_point" do
      expect(  SearchRoutesService.search('driver',9,7) ).to eq([])
    end 

    it "not search route with route_type passenger finish city in start_city" do
      expect(  SearchRoutesService.search('driver',9,7) ).to eq([])
    end
    it "not search route with  start_city in start_point finish city in finish_point but wrong route_type" do
      expect(  SearchRoutesService.search('passenger',1,3) ).to eq([])
    end 

    it "not search route with  start_city in start_point finish city in intermediate but wrong route_type" do
      expect(  SearchRoutesService.search('passenger',1,2) ).to eq([])
    end

    it "not search route with  start_city in intermediate finish city in finish_point but wrong route_type" do
      expect(  SearchRoutesService.search('passenger',2,3) ).to eq([])
    end 

    it "not search route with route_type driver  start_city in start_point and finish city in finish_point but in wrong association " do
      expect(  SearchRoutesService.search('driver',1,6) ).to eq([])
    end

    it "not search route with route_type driver  start_city in start_point and finish city in intermediate but in wrong association " do
      expect(  SearchRoutesService.search('driver',1,5) ).to eq([])
    end

    it "not search route with route_type driver  start_city in intermediate and finish city in finish_point but in wrong association " do
      expect(  SearchRoutesService.search('driver',2,6) ).to eq([])
    end

    it "not search route with route_type driver  start_city in intermediate and finish city in intermediate but in wrong association " do
      expect(  SearchRoutesService.search('driver',2,5) ).to eq([])
    end

    it "not search route with route_type passenger  start_city in start_point and finish city in finish_point but in wrong association " do
      expect(  SearchRoutesService.search('passenger',7,12) ).to eq([])
    end

    it "not search route with route_type passenger  start_city in start_point and finish city in intermediate but in wrong association " do
      expect(  SearchRoutesService.search('passenger',7,11) ).to eq([])
    end

    it "not search route with route_type passenger  start_city in intermediate and finish city in finish_point but in wrong association " do
      expect(  SearchRoutesService.search('passenger',8,12) ).to eq([])
    end

    it "not search route with route_type passenger  start_city in intermediate and finish city in intermediate but in wrong association " do
      expect(  SearchRoutesService.search('passenger',8,11) ).to eq([])
    end

    it "not search route with route_type passenger  start_city in intermediate and finish city in another intermediate but the same track" do
      expect(  SearchRoutesService.search('passenger',12,14) ).to eq([])
    end

    it "not search route with route_type driver  start_city in intermediate and finish city in another intermediate but the same track" do
      expect(  SearchRoutesService.search('driver',2,15) ).to eq([])
    end
  end  
end