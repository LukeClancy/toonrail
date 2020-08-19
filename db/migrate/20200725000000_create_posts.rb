class CreatePosts < ActiveRecord::Migration[5.2]
    def change
        #note description replaced with text later on in CreateUsers
        create_table :posts do |t|
          t.string :title
          t.string :picture_url, default: nil
          t.string :description
          #hopefuly thats how default works
        end
    end
  end