class AddSolutionToIdToCell < ActiveRecord::Migration[5.0]
  def change
    add_column :cells, :solution_to_id, :integer
  end
end
