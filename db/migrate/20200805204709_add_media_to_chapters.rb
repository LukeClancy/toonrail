class AddMediaToChapters < ActiveRecord::Migration[5.2]
  def change
    add_column :chapters, :media, :json
  end
end
