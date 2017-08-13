class Attraction < ActiveRecord::Base
  attr_accessor :country
  
  belongs_to :user
  belongs_to :category
  
  validates :user_id, presence: true
  default_scope -> { order(created_at: :desc) }
end
