class CreateRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :routes do |t|
      t.string :name
      t.integer :route_type
      t.integer :seats, :default => 1

      t.timestamps
    end
  end
end
