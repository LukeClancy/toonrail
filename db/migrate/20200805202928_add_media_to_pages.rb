class AddMediaToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :media, :json
  end
end
