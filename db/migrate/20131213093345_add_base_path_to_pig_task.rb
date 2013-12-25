class AddBasePathToPigTask < ActiveRecord::Migration
  def change
    add_column :pig_tasks, :base_path, :string
  end
end
