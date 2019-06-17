class ChangeCenterTypeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :centers, :type, :center_type
  end
end
