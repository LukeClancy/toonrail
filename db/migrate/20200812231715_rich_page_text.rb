class RichPageText < ActiveRecord::Migration[6.0]
    def change
      remove_column :pages, :text
      #text then added back in model
    end
  end
  