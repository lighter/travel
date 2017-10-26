class CreateAttractionPhotos < ActiveRecord::Migration
  def change
    create_table :attraction_photos do |t|
      t.integer :attraction_id
      t.string :photo

      t.timestamps null: false
    end
  end
end
