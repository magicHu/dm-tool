class AddStatusToPigTask < ActiveRecord::Migration
  def change
    add_column :pig_tasks, :name, :string
    add_column :pig_tasks, :status, :integer, :default => 1
  end
end
