class AddOrderToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :order, :integer
    add_index :pages, [:chapter_id, :order]
    #Ex:- add_index("admin_users", "username")
  end
end
