require 'test_helper'

class GridsControllerTest < ActionDispatch::IntegrationTest
  test "can create a new maze" do
    post grids_path
    id = Grid.all.last.id
    assert_redirected_to grid_path(id)
  end

  test "can solve a maze" do
    post grids_path
    id = Grid.all.last.id
    patch grid_path(id)
    assert_redirected_to grid_path(id)
  end
end
