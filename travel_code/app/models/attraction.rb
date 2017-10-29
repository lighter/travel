class Attraction < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :attraction_photos, dependent: :destroy

  has_many :user_relationships, class_name: "Relationship", foreign_key: "attraction_id", dependent: :destroy

  accepts_nested_attributes_for :attraction_photos

  validates :user_id, presence: true
  validates :name, presence: true, length: {maximum: 100}
  validates :latitude, numericality: {only_float: true}
  validates :longitude, numericality: {only_float: true}
  validates :address, length: {maximum: 255}
  validates :phone, length: {maximum: 20}
  validates :category_id, numericality: {only_integer: true}

  default_scope {order(created_at: :desc)}
  default_scope {where(deleted_at: nil)}

  def soft_delete
    update(deleted_at: Time.current)
  end
end
