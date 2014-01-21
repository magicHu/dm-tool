class AddOutputToJobsParams < ActiveRecord::Migration
  def change
    add_column :jobs_params, :output, :boolean, :default_value => false
  end
end
