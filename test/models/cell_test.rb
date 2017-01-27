require 'test_helper'

class CellTest < ActiveSupport::TestCase
  test "can check if a cell is a dead end" do
    my_grid = Grid.create!(side_length: 5)
    my_grid.setup_grid
    my_cell = my_grid.cell_at(2,3)
    my_cell.top_neighbor.visited!
    my_cell.left_neighbor.visited!
    my_cell.right_neighbor.visited!
    my_cell.bottom_neighbor.visited!
    assert my_cell.dead_end?
  end

  test "can get neighboring cells" do
    my_grid = Grid.create!(side_length: 5)

    my_grid.setup_grid
    cell = my_grid.cell_at(2, 3)
    neighbors = cell.neighboring_cells
    assert_equal 4, neighbors.size
    assert_equal 1, neighbors[:left].x_pos
    assert_equal 3, neighbors[:left].y_pos
  end

  test "can remove wall from cell, which also removes wall from neighboring cell" do
    my_grid = Grid.create(side_length: 5)
    my_grid.setup_grid
    cell = my_grid.cell_at(2, 3)
    cell.remove_wall(:left)
    cell.remove_wall(:top)
    refute cell.left_wall
    refute cell.left_neighbor.right_wall
    refute cell.top_neighbor.bottom_wall
  end

  test "can pick random unvisited neighboring direction" do
    my_grid = Grid.create(side_length: 5)
    my_grid.setup_grid
    current_cell = my_grid.cell_at(3, 4)
    direction = current_cell.rand_unvisited_direction
    assert_equal Symbol, direction.class
    assert [:top, :bottom, :left, :right].include?(direction)
  end

  test "can mark a cell as visited" do
    my_grid = Grid.create(side_length: 5)
    my_grid.setup_grid
    current_cell = my_grid.cell_at(3, 4)
    refute current_cell.visited
    current_cell.visited!
    assert current_cell.visited
  end

  test "can check number of walls of a cell" do
    my_grid = Grid.create(side_length: 5)
    my_grid.setup_grid
    current_cell = my_grid.cell_at(2, 3)
    current_cell.remove_wall(:left)
    assert_equal 3, current_cell.number_walls
    assert_equal 3, current_cell.left_neighbor.number_walls
  end

  test "can get list of classes for display" do
    my_grid = Grid.create(side_length: 6)
    my_grid.setup_grid
    current_cell = my_grid.cell_at(3, 4)
    current_cell.remove_wall(:left)
    assert_equal "right top bottom", current_cell.css_classes
  end

  test "can find the edge of a cell if it exists" do
    my_grid = Grid.create(side_length: 6)
    my_grid.setup_grid
    current_cell = my_grid.cell_at(3, 5)
    assert_equal :top, current_cell.find_edge
  end

  test "can determine if a cell is a dead end in the maze" do
    my_grid = Grid.create(side_length: 6)
    my_grid.setup_grid
    cell = my_grid.cell_at(2, 3)
    cell.remove_wall(:left)
    assert cell.maze_dead_end?
    cell.remove_wall(:right)
    refute cell.maze_dead_end?
  end

  test "can check possible open directions to travel" do
    my_grid = Grid.create(side_length: 6)
    my_grid.setup_grid
    cell = my_grid.cell_at(2, 3)
    cell.remove_wall(:left)
    assert_equal [:left], cell.possible_directions
  end
end
