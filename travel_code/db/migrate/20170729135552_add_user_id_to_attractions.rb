class AddUserIdToAttractions < ActiveRecord::Migration
  def change
    add_column :attractions, :user_id, :integer
  end
end
