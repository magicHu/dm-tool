class CreateTaskJobs < ActiveRecord::Migration
  def change
    create_table :task_jobs do |t|
      t.references :pig_task
      t.references :job
      t.integer :position

      t.timestamps
    end
  end
end
