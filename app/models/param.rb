class Param < ActiveRecord::Base

  has_and_belongs_to_many :jobs

  @@field_types = { 'path' => 'path', 'date' => 'date', 'number' => 'number', 'string' => 'string' }

  validates :name, :desc, :field_type, presence: true
  
  def self.field_types
    @@field_types
  end

  def is_path?
    field_type == 'path'
  end

end
