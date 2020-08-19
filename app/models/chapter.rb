class Chapter < ApplicationRecord
    has_many :pages
    mount_uploader :media, MediaUploader
end
