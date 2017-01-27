class AddVistedFlagToCell < ActiveRecord::Migration[5.0]
  def change
    add_column :cells, :visited, :boolean
  end
end
