
class Page < ApplicationRecord
    belongs_to :user
    belongs_to :chapter
    mount_uploader :media, MediaUploader
    acts_as_commentable
    before_save :_persist_order_save
    before_destroy :_persist_order_destroy
end
