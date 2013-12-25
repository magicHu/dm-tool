class TaskJob < ActiveRecord::Base
  belongs_to :pig_task
  belongs_to :job

  acts_as_list :scope => :pig_task
end
