class AttractionPhoto < ActiveRecord::Base
  belongs_to :attraction, -> { with_deleted }

  mount_uploader :photo, AttractionImageUploader

  default_scope {where(deleted_at: nil)}
  
  def soft_delete
    update(deleted_at: Time.current)
  end
end
