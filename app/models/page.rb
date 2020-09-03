
class Page < ApplicationRecord
    belongs_to :user
    belongs_to :chapter
    mount_uploader :media, MediaUploader
    acts_as_commentable
end
