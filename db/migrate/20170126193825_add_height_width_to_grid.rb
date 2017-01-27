class AddHeightWidthToGrid < ActiveRecord::Migration[5.0]
  def change
    add_column :grids, :side_length, :integer
    remove_column :grids, :size, :integer
  end
end
