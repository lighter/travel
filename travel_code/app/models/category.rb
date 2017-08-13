class Category < ActiveRecord::Base

  has_many :attractions

  default_scope -> {where(deleted_at: nil)}

  def soft_delete
    update(deleted_at: Time.current)
  end
end
