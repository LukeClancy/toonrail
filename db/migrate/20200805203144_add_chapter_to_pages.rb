class AddChapterToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :chapter_id, :integer
  end
end