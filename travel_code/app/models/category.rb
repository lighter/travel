class Category < ActiveRecord::Base
  belongs_to :user
  has_many :attractions
  
  validates :name, presence: true, length: { maximum: 20 }

  validates_uniqueness_of :name

  default_scope {where(deleted_at: nil)}

  def soft_delete
    update(deleted_at: Time.current)
  end
end
