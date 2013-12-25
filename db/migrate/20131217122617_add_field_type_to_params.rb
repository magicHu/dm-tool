class AddFieldTypeToParams < ActiveRecord::Migration
  def change
    add_column :params, :field_type, :string
  end
end
