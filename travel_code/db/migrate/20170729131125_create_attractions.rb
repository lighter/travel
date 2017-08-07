class CreateAttractions < ActiveRecord::Migration
  def change
    create_table :attractions do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :phone
      t.integer :type
      t.timestamps null: false
    end
  end
end
