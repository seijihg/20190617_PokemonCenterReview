class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    def create_table do |t|
      t.string :content
      t.integer :rating
      t.integer :user_id
      t.integer :center_id
    end
  end
end
