require 'test_helper'

class IteratorTest < ActiveSupport::TestCase

  def setup
    @grid = Grid.create!(side_length: 5)
    @grid.setup_grid
    @iterator = Iterator.new(@grid)
  end

  test "picks random start point when initialized" do
    assert @iterator.start_cell.x_pos == 4 || @iterator.start_cell.y_pos == 4
  end

  test "can move one space" do
    current_cell = @iterator.start_cell
    stack = []
    new_cell = @iterator.move_once(current_cell, stack)
    assert_equal 1, stack.size
    refute_equal current_cell, new_cell
    assert current_cell.visited
    assert current_cell.neighbors?(new_cell)
    assert_equal 2, current_cell.number_walls
    assert_equal 3, new_cell.number_walls
  end

  test "can create maze" do
    @iterator.create_maze
    assert Grid.find(@iterator.grid.id).all_cells_visited
  end

  test "can solve an existing maze" do
    maze = @iterator.create_maze
    new_iterator = Iterator.new(maze)
    new_iterator.solve_maze
    assert maze.solution_cells.size < maze.side_length ** 2
    assert maze.solution_cells.size > 0
  end

end
