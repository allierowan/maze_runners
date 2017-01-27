require 'test_helper'

class GridTest < ActiveSupport::TestCase

  test "can create a grid of a given side with the correct cells" do
    my_grid = Grid.create(side_length: 5)
    my_grid.setup_grid
    assert_equal 25, my_grid.cells.size
    assert_equal 0, my_grid.cells.first.x_pos
    assert_equal 0, my_grid.cells.first.y_pos
    assert_equal 4, my_grid.cells.last.x_pos
    assert_equal 4, my_grid.cells.last.y_pos
  end

  test "can get a certain cell from a grid based on position" do
    my_grid = Grid.create(side_length: 5)
    my_grid.setup_grid
    cell = my_grid.cell_at(2, 3)
    assert_equal 2, cell.x_pos
    assert_equal 3, cell.y_pos
  end

  test "can check if all cells have been visited" do
    my_grid = Grid.create(side_length: 5)
    my_grid.setup_grid
    refute my_grid.all_cells_visited
    my_grid.cells.each {|cell| cell.update(visited: true)}
    assert my_grid.all_cells_visited
  end

  test "can find all cell in a maze that are dead ends" do
    my_grid = Grid.create(side_length: 5)
    my_grid.setup_grid
    iterator = Iterator.new(my_grid)
    maze = iterator.create_maze
    cells = maze.find_dead_ends
    assert_equal Array, cells.class
    assert cells.sample.maze_dead_end?
  end
end
