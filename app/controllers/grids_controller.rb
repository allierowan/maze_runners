class GridsController < ApplicationController
  def create
    grid = Grid.create(side_length: 10)
    grid.setup_grid
    iterator = Iterator.new(grid)
    maze = iterator.create_maze
    redirect_to grid_path(maze.id)
  end

  def update
    @maze = Grid.find(params[:id])
    iterator = Iterator.new(@maze)
    iterator.solve_maze
    redirect_to grid_path(@maze.id)
  end

  def show
    @maze = Grid.find(params[:id])
  end
end
