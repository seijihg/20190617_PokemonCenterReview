class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    def create_table :users do |t|
      t.string :name
      t.integer :age
    end
  end
end
