class AddPageText < ActiveRecord::Migration[6.0]
    def change
        #moving away from trix and towards summernote, because the basic design of trix is bad
        #and it looks kinda janky to be honest.
        add_column :pages, :text, :text
    end
  end
  