class AddCommentsComment < ActiveRecord::Migration[6.0]
    def change
        #moving away from trix and towards summernote, because the basic design of trix is bad
        #and it looks kinda janky to be honest.
        add_column :comments, :comment, :text
    end
end
  