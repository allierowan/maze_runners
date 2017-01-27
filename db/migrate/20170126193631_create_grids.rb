class CreateGrids < ActiveRecord::Migration[5.0]
  def change
    create_table :grids do |t|
      t.integer :size

      t.timestamps
    end
  end
end
