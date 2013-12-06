class CreateParams < ActiveRecord::Migration
  def change
    create_table :params do |t|
      t.string :name
      t.string :desc
      t.string :default_value

      t.timestamps
    end

    create_table :jobs_params do |t|
      t.belongs_to :job
      t.belongs_to :param
    end
  end
end
