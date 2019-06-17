class CreateCenters < ActiveRecord::Migration[5.2]
  def change
    def create_table do |t|
      t.string :center
      t.string :type
    end
  end
end
