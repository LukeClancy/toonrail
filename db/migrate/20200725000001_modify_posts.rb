class ModifyPosts < ActiveRecord::Migration[5.2]
    def change
        change_table :posts do |t|
            t.integer :user_id
        end
    end
  end