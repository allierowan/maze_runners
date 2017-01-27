class Cell < ApplicationRecord
  belongs_to :grid
  belongs_to :solution_to, class_name: "Grid", foreign_key: "solution_to_id", optional: true
  has_one :grid_start, foreign_key: "start_cell_id"
  has_one :grid_end, foreign_key: "end_cell_id"

  def visited!
    self.update!(visited: true)
  end

  def grid_width
    grid.side_length
  end

  def dead_end?
    (left_neighbor == nil || left_neighbor.visited) && (right_neighbor == nil || right_neighbor.visited) && (top_neighbor == nil || top_neighbor.visited) && (bottom_neighbor == nil || bottom_neighbor.visited)
  end

  def maze_dead_end?
    number_walls == 3
  end

  def neighboring_cells
    {left: left_neighbor, right: right_neighbor, top: top_neighbor, bottom: bottom_neighbor}.compact
  end

  def rand_unvisited_direction
    neighboring_cells.select { |k, v| !v.visited }.to_a.sample.first
  end

  def neighbor_to(direction)
    if direction == :left
      left_neighbor
    elsif direction == :right
      right_neighbor
    elsif direction == :bottom
      bottom_neighbor
    elsif direction == :top
      top_neighbor
    else
      raise InvalidDirection
    end
  end

  def left_neighbor
    if self.x_pos == 0
      nil
    else
      grid.cell_at(self.x_pos - 1, self.y_pos)
    end
  end

  def right_neighbor
    if self.x_pos == grid_width - 1
      nil
    else
      grid.cell_at(self.x_pos + 1, self.y_pos)
    end
  end

  def top_neighbor
    if self.y_pos == grid_width - 1
      nil
    else
      grid.cell_at(self.x_pos, self.y_pos + 1)
    end
  end

  def bottom_neighbor
    if self.y_pos == 0
      nil
    else
      grid.cell_at(self.x_pos, self.y_pos - 1)
    end
  end

  def remove_wall(direction)
    if direction == :left
      self.update(left_wall: false)
      self.left_neighbor.update(right_wall: false) if left_neighbor
    elsif direction == :right
      self.update(right_wall: false)
      right_neighbor.update(left_wall: false) if right_neighbor
    elsif direction == :top
      self.update(top_wall: false)
      top_neighbor.update(bottom_wall: false) if top_neighbor
    elsif direction == :bottom
      self.update(bottom_wall: false)
      bottom_neighbor.update(top_wall: false) if bottom_neighbor
    else
      raise InvalidDirection
    end
  end

  def neighbors?(other_cell)
    (self.left_neighbor && other_cell == self.left_neighbor) || (self.right_neighbor && other_cell == self.right_neighbor) || (self.bottom_neighbor && other_cell == self.bottom_neighbor) || (self.top_neighbor && other_cell == self.top_neighbor)
  end

  def number_walls
    walls = [left_wall, right_wall, bottom_wall, top_wall]
    walls.reduce(0) do |i, wall|
      if wall
        i + 1
      else
        i + 0
      end
    end
  end

  def starting_cell?
    self == grid.start_cell
  end

  def ending_cell?
    self == grid.end_cell
  end

  def css_classes
    left_string = ("left " if left_wall) || ""
    right_string = ("right " if right_wall) || ""
    top_string = ("top " if top_wall) || ""
    bottom_string = ("bottom " if bottom_wall) || ""
    start_string = ("start_cell " if starting_cell?) || ""
    end_string = ("end_cell " if ending_cell?) || ""
    solution_string = ("solution " if solution_cell?) || ""

    class_string = left_string + right_string + top_string + bottom_string + start_string + end_string + solution_string
    class_string.strip
  end

  def find_edge
    directions = [:left, :right, :top, :bottom]
    direction = nil
    present = true
    until !present || directions.empty?
      direction = directions.sample
      directions -= [direction]
      present = neighbor_to(direction)
    end
    direction
  end

  def junction?
    number_walls <= 2
  end

  def possible_directions
    directions = []
    directions << :left if !left_wall
    directions << :right if !right_wall
    directions << :top if !top_wall
    directions << :bottom if !bottom_wall
    directions.compact
  end

  def move_to(direction)
    neighbor_to(direction)
  end

  def solution_cell?
    solution_positions = grid.solution_cells.map do |cell|
      [cell.x_pos, cell.y_pos]
    end
    solution_positions.include?([self.x_pos, self.y_pos])
  end

  def build_wall(direction)
    if direction == :left
      self.update(left_wall: true)
      self.left_neighbor.update(right_wall: true) if left_neighbor
    elsif direction == :right
      self.update(right_wall: true)
      right_neighbor.update(left_wall: true) if right_neighbor
    elsif direction == :top
      self.update(top_wall: true)
      top_neighbor.update(bottom_wall: true) if top_neighbor
    elsif direction == :bottom
      self.update(bottom_wall: true)
      bottom_neighbor.update(top_wall: true) if bottom_neighbor
    else
      raise InvalidDirection
    end
  end

end
