class AddStartCellIdToGrid < ActiveRecord::Migration[5.0]
  def change
    add_column :grids, :start_cell_id, :integer
  end
end
