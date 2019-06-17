class CreateCenters < ActiveRecord::Migration[5.2]
  def change
    create_table :centers do |t|
      t.string :center
      t.string :type
    end
  end
end
