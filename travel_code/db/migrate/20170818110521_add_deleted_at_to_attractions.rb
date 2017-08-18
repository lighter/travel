class AddDeletedAtToAttractions < ActiveRecord::Migration
  def change
    add_column :attractions, :deleted_at, :datetime
  end
end
