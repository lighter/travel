class AttractionPhoto < ActiveRecord::Base
  belongs_to :attraction

  mount_uploaders :photo, AttractionImageUploader

  serialize :photo
end
