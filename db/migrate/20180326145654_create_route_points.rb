class CreateRoutePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :route_points do |t|
      t.references :route, foreign_key: true
      t.integer :city_id
      t.integer :point_type
      t.datetime :point_at

      t.timestamps
    end
  end
end
