class Category < ActiveRecord::Base
  default_scope -> {where(deleted_at: nil)}

  def soft_delete
    update(deleted_at: Time.current)
  end
end
