class AddEndCellIdToGrid < ActiveRecord::Migration[5.0]
  def change
    add_column :grids, :end_cell_id, :integer
  end
end
