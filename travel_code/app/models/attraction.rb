class Attraction < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  validates :user_id, presence: true
  validates :name, presence: true, length: {maximum: 100}
  validates :latitude, numericality: {only_float: true}
  validates :longitude, numericality: {only_float: true}
  validates :address, length: {maximum: 255}
  validates :phone, length: {maximum: 20}
  validates :category_id, numericality: {only_integer: true}
  
  default_scope -> {order(created_at: :desc)}
end
