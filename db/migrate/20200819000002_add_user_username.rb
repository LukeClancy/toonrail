class AddUserUsername < ActiveRecord::Migration[6.0]
    def change
        #moving away from trix and towards summernote, because the basic design of trix is bad
        #and it looks kinda janky to be honest.
        add_column :users, :username, :string
        add_index :users, :username, unique: true
    end
end
  