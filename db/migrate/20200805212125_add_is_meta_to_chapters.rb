class AddIsMetaToChapters < ActiveRecord::Migration[5.2]
  def change
    add_column :chapters, :is_meta, :boolean
  end
end
