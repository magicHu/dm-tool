class CreatePigTasks < ActiveRecord::Migration
  def change
    create_table :pig_tasks do |t|
      t.text :command

      t.timestamps
    end
  end
end
