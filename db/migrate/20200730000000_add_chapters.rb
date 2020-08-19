class AddChapters < ActiveRecord::Migration[5.2]
    def change
        change_table :posts do |t|
            t.integer :chapter, default: 1
        end
    end
end