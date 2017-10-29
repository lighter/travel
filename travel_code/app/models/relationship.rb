class Relationship < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :attraction, class_name: "Attraction"

  validates :user_id, presence: true
  validates :attraction_id, presence: true
end
