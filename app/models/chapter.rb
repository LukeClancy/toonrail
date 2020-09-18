class Chapter < ApplicationRecord
    belongs_to :user
    has_many :pages
    mount_uploader :media, MediaUploader
    before_save :_persist_order_save
    before_destroy :_persist_order_destroy

end
