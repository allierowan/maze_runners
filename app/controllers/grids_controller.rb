class GridsController < ApplicationController
  def create
    @grid = Grid.new(side_length: 10)
    if @grid.save
      @grid.setup_grid
      iterator = Iterator.new(@grid)
      maze = iterator.create_maze
      redirect_to grid_path(maze.id)
    else
      render root_path
    end
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
