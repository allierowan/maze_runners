require 'grid'
require 'cell'

class Iterator

  attr_accessor :grid
  attr_reader :start_cell

  def initialize(grid)
    @grid = grid
    @start_cell = @grid.start_cell
  end

  def create_maze
    current_cell = self.start_cell
    stack = []
    until grid.cells.where("visited").size == grid.side_length ** 2
      if !current_cell.dead_end?
        current_cell = move_once(current_cell, stack)
      else
        current_cell = stack.pop if stack
      end
    end
    current_cell.grid
  end

  def solve_maze
    maze_cells = []
    grid.cells.each do |cell|
      cell_copy = cell.dup
      cell_copy.save
      maze_cells << cell_copy
    end
    grid_copy = Grid.create(side_length: grid.side_length, cells: maze_cells)
    solution_cells = grid_copy.cells
    all_dead_ends = grid_copy.find_dead_ends
    all_dead_ends.each do |cell|
      solution_cells = fill_in_dead_end(cell, solution_cells)
    end
    grid.update!(solution_cells: solution_cells)
  end

  def fill_in_dead_end(cell, solution_cells)
    until cell.junction?
      solution_cells -= [cell]
      direction = cell.possible_directions.first
      cell.build_wall(direction)
      cell = cell.move_to(direction)
    end
    solution_cells
  end

  def move_once(current_cell, stack)
    current_cell.visited!
    stack << current_cell
    unvisited_direction = current_cell.rand_unvisited_direction
    current_cell.remove_wall(unvisited_direction)
    current_cell.neighbor_to(unvisited_direction).visited!
    return current_cell.neighbor_to(unvisited_direction)
  end

  def opposite_direction(direction)
    if direction == :left
      :right
    elsif direction == :right
      :left
    elsif direction == :top
      :bottom
    elsif direction == :bottom
      :top
    elsif direction == nil
      nil
    else
      raise InvalidDirection
    end
  end

end
