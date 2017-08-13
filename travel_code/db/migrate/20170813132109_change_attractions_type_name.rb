class ChangeAttractionsTypeName < ActiveRecord::Migration
  def change
    rename_column :attractions, :type, :category_id
  end
end
