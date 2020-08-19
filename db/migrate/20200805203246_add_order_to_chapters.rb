class AddOrderToChapters < ActiveRecord::Migration[5.2]
  def change
    add_column :chapters, :order, :integer
  end
end
