class Page < ApplicationRecord
    belongs_to :user
    belongs_to :chapter
    mount_uploader :media, MediaUploader
    has_rich_text :text
    acts_as_commentable
end
