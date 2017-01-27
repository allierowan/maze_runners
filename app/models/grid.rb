class Grid < ApplicationRecord
  has_many :cells
  has_many :solution_cells, class_name: "Cell", foreign_key: "solution_to_id"
  belongs_to :start_cell, class_name: "Cell", foreign_key: "start_cell_id", optional: true
  belongs_to :end_cell, class_name: "Cell", foreign_key: "end_cell_id", optional: true

  def setup_grid
    side_length.times do |y|
      side_length.times do |x|
        self.cells.create!(x_pos: x, y_pos: y, left_wall: true, right_wall: true, bottom_wall: true, top_wall: true, visited: false)
      end
    end
    set_start_cell!
    set_end_cell!
  end

  def cell_at(x, y)
    self.cells.where("x_pos = #{x} and y_pos = #{y}").first
  end

  def all_cells_visited
    cells.select {|cell| !cell.visited}.empty?
  end

  def set_start_cell!
    cell = cells.where("x_pos = #{side_length - 1} OR y_pos = #{side_length - 1}").sample
    cell.remove_wall(cell.find_edge)
    self.update(start_cell: cell)
  end

  def set_end_cell!
    x = (side_length - 1 - start_cell.x_pos).abs
    y = (side_length - 1 - start_cell.y_pos).abs
    end_cell = cell_at(x, y)
    end_cell.remove_wall(end_cell.find_edge)
    self.update(end_cell: end_cell)
  end

  def find_dead_ends
    cells.select { |cell| cell.maze_dead_end? }
  end

end
