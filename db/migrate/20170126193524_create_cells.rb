class CreateCells < ActiveRecord::Migration[5.0]
  def change
    create_table :cells do |t|
      t.integer :x_pos
      t.integer :y_pos
      t.boolean :left_wall
      t.boolean :right_wall
      t.boolean :bottom_wall
      t.boolean :top_wall
      t.integer :grid_id

      t.timestamps
    end
  end
end
