class AddConstraints < ActiveRecord::Migration[5.2]
  def change
    change_column_default :pages, :text, ""
    change_column_null :pages, :media, false
    change_column_null :pages, :title, false
    change_column_null :chapters, :title, false
  end
end
