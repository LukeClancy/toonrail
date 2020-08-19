class CreateUsers < ActiveRecord::Migration[5.2]
    def change
        change_table :posts do |t|
            t.text :text
        end
        remove_column :posts, :description
    end
end
