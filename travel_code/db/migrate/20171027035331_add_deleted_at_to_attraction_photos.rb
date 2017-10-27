class AddDeletedAtToAttractionPhotos < ActiveRecord::Migration
  def change
    add_column :attraction_photos, :deleted_at, :datetime
  end
end
